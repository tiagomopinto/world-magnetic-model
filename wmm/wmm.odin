package world_magnetic_model

import "core:c"
import "core:fmt"
import "core:os"
import "core:strings"

Wmm_Context :: struct {
	magnetic_model_ptr:   ^Magnetic_Model,
	timed_mag_model_ptr:  ^Magnetic_Model,
	geodetic_coord:       Geodetic,
	spherical_coord:      Spherical,
	ellipsoid:            Ellipsoid,
	geoid:                Geoid,
	user_date:            Date,
	geomagnetic_elements: Geomagetic_Elements,
	date_error_message:   ^c.char,
}

get_magnetic_field_ned :: proc(wmm: ^Wmm_Context) {

	if wmm_date_to_year(&wmm.user_date, wmm.date_error_message) == 0 {

		fmt.println(strings.clone_from_ptr(wmm.date_error_message, 200))
		os.exit(1)
	}

	wmm_geodetic_to_spherical(wmm.ellipsoid, wmm.geodetic_coord, &wmm.spherical_coord)

	wmm_timely_mod_mag_model(wmm.user_date, wmm.magnetic_model_ptr, wmm.timed_mag_model_ptr)

	wmm_geomag(
		wmm.ellipsoid,
		wmm.spherical_coord,
		wmm.geodetic_coord,
		wmm.timed_mag_model_ptr,
		&wmm.geomagnetic_elements,
	)

	return
}

make_wmm :: proc(file_name: cstring) -> (wmm: ^Wmm_Context) {

	wmm = new(Wmm_Context)

	assert(wmm != nil, "Memory allocation failed for wmm_context in make_wmm().")

	error_msg_buffer := make([]c.char, 200)

	assert(error_msg_buffer != nil, "Memory allocation failed for error_msg_buffer in make_wmm().")

	wmm.date_error_message = &error_msg_buffer[0]

	epochs: c.int = 1

	err := wmm_read_mag_models(file_name, &wmm.magnetic_model_ptr, epochs)

	assert(err != 0, "WMM.COF not found in make_wmm().")

	assert(
		wmm.magnetic_model_ptr != nil,
		"Memory allocation failed for mag_model_ptr in make_wmm().",
	)

	n_max: c.int

	if n_max < wmm.magnetic_model_ptr.n_max {

		n_max = wmm.magnetic_model_ptr.n_max
	}

	num_terms := (n_max + 1) * (n_max + 2) / 2

	wmm.timed_mag_model_ptr = wmm_allocate_model(num_terms)

	assert(
		wmm.timed_mag_model_ptr != nil,
		"Memory allocation failed for timed_mag_model_ptr in make_wmm().",
	)

	wmm_set_defaults(&wmm.ellipsoid, &wmm.geoid)

	return
}

free_wmm :: proc(wmm: ^^Wmm_Context) {

	free(wmm^.date_error_message)

	wmm_free_model(wmm^^.timed_mag_model_ptr)

	wmm^^.timed_mag_model_ptr = nil

	wmm_free_model(wmm^.magnetic_model_ptr)

	wmm^^.magnetic_model_ptr = nil

	free(wmm^)

	wmm^ = nil
}

