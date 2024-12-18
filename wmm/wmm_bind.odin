#+private package
package world_magnetic_model

import "core:c"

when ODIN_OS == .Windows {

	foreign import wmm "../bin/wmm.lib"

} else when ODIN_OS == .Linux {

	foreign import wmm "../bin/wmm.a"

} else when ODIN_OS == .Darwin {

	foreign import wmm "../bin/wmm.a"
}

foreign wmm {

	@(link_name = "MAG_robustReadMagModels")
	wmm_read_mag_models :: proc "c" (file_name: cstring, magnetic_model: ^^Magnetic_Model, array_size: c.int) -> c.int ---

	@(link_name = "MAG_AllocateModelMemory")
	wmm_allocate_model :: proc "c" (Num_terms: c.int) -> ^Magnetic_Model ---

	@(link_name = "MAG_SetDefaults")
	wmm_set_defaults :: proc "c" (ellip: ^Ellipsoid, geoid: ^Geoid) -> c.int ---

	@(link_name = "MAG_FreeMagneticModelMemory")
	wmm_free_model :: proc "c" (mag_model: ^Magnetic_Model) -> c.int ---

	@(link_name = "MAG_GeodeticToSpherical")
	wmm_geodetic_to_spherical :: proc "c" (ellip: Ellipsoid, geodetic: Geodetic, spherical: ^Spherical) -> c.int ---

	@(link_name = "MAG_TimelyModifyMagneticModel")
	wmm_timely_mod_mag_model :: proc "c" (user_date: Date, magnetic_model: ^Magnetic_Model, timed_magnetic_model: ^Magnetic_Model) -> c.int ---

	@(link_name = "MAG_Geomag")
	wmm_geomag :: proc "c" (ellip: Ellipsoid, spherical: Spherical, geodetic: Geodetic, timed_magnetic_model: ^Magnetic_Model, geomagnetic_elements: ^Geomagetic_Elements) -> c.int ---

	@(link_name = "MAG_DateToYear")
	wmm_date_to_year :: proc "c" (date: ^Date, error_msg: ^c.char) -> c.int ---
}

Magnetic_Model :: struct {
	edition_date:              f64,
	epoch:                     f64,
	model_name:                [32]u8,
	main_field_coeff_G:        ^f64,
	main_field_coeff_H:        ^f64,
	secular_var_coeff_G:       ^f64,
	secular_car_coeff_H:       ^f64,
	n_max:                     c.int,
	n_max_sec_var:             c.int,
	secular_variation_used:    c.int,
	coefficient_file_end_date: f64,
}

Ellipsoid :: struct {
	a:     f64,
	b:     f64,
	fla:   f64,
	epssq: f64,
	eps:   f64,
	re:    f64,
}

Geoid :: struct {
	mumb_geoid_cols:     c.int,
	numb_geoid_rows:     c.int,
	numb_header_items:   c.int,
	scale_factor:        c.int,
	geoid_height_buffer: ^f64,
	numb_geoid_elevs:    c.int,
	geoid_initialized:   c.int,
	use_geoid:           c.int,
}

Geodetic :: struct {
	lambda:                 f64,
	phi:                    f64,
	height_above_ellipsoid: f64,
	height_above_geoid:     f64,
	use_geoid:              c.int,
}

Spherical :: struct {
	lambda: f64,
	phig:   f64,
	r:      f64,
}

Date :: struct {
	year:         c.int,
	month:        c.int,
	day:          c.int,
	decimal_year: f64,
}

Geomagetic_Elements :: struct {
	decl:     f64,
	incl:     f64,
	f:        f64,
	h:        f64,
	x:        f64,
	y:        f64,
	z:        f64,
	gv:       f64,
	decl_dot: f64,
	incl_dot: f64,
	f_dot:    f64,
	h_dot:    f64,
	x_dot:    f64,
	y_dot:    f64,
	z_dot:    f64,
	gv_dot:   f64,
}

