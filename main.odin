package main

import "core:fmt"
import "wmm"

main :: proc() {

	wmm_data := wmm.make_wmm("WMM.COF")

	defer wmm.free_wmm(&wmm_data)

	wmm_data.user_date.year = 2025
	wmm_data.user_date.month = 1
	wmm_data.user_date.day = 1

	wmm_data.geodetic_coord.phi = 89.0 // deg
	wmm_data.geodetic_coord.lambda = -121.0 // deg
	wmm_data.geodetic_coord.height_above_ellipsoid = 28.0 // km

	wmm.get_magnetic_field_ned(wmm_data)

	fmt.printfln(
		"Date: %04v/%02v/%02v",
		wmm_data.user_date.year,
		wmm_data.user_date.month,
		wmm_data.user_date.day,
	)
	fmt.printfln("Lat : %.2f deg", wmm_data.geodetic_coord.phi)
	fmt.printfln("Lon : %.2f deg", wmm_data.geodetic_coord.lambda)
	fmt.printfln("Alt : %.2f m (above ellipsoid)", wmm_data.geodetic_coord.height_above_ellipsoid)
	fmt.printfln(
		"Magnetic field (nT): [%.4f %.4f %.4f]",
		wmm_data.geomagnetic_elements.x,
		wmm_data.geomagnetic_elements.y,
		wmm_data.geomagnetic_elements.z,
	)
}

