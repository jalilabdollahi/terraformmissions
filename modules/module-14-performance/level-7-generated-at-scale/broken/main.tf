# Fairmount Park stadium: one tag file per seat.
# Blocks A-F, rows 1-5, seats 01-10 = 300 seats, each pasted by hand.
# Refactor into a single for_each resource. Every existing file must keep its identity.

resource "local_file" "seat_a_1_01" {
  filename = "${path.module}/seats/a-1-01.txt"
  content  = "Block A, row 1, seat 01\n"
}

resource "local_file" "seat_a_1_02" {
  filename = "${path.module}/seats/a-1-02.txt"
  content  = "Block A, row 1, seat 02\n"
}

resource "local_file" "seat_a_1_03" {
  filename = "${path.module}/seats/a-1-03.txt"
  content  = "Block A, row 1, seat 03\n"
}

resource "local_file" "seat_a_1_04" {
  filename = "${path.module}/seats/a-1-04.txt"
  content  = "Block A, row 1, seat 04\n"
}

resource "local_file" "seat_a_1_05" {
  filename = "${path.module}/seats/a-1-05.txt"
  content  = "Block A, row 1, seat 05\n"
}

resource "local_file" "seat_a_1_06" {
  filename = "${path.module}/seats/a-1-06.txt"
  content  = "Block A, row 1, seat 06\n"
}

resource "local_file" "seat_a_1_07" {
  filename = "${path.module}/seats/a-1-07.txt"
  content  = "Block A, row 1, seat 07\n"
}

resource "local_file" "seat_a_1_08" {
  filename = "${path.module}/seats/a-1-08.txt"
  content  = "Block A, row 1, seat 08\n"
}

resource "local_file" "seat_a_1_09" {
  filename = "${path.module}/seats/a-1-09.txt"
  content  = "Block A, row 1, seat 09\n"
}

resource "local_file" "seat_a_1_10" {
  filename = "${path.module}/seats/a-1-10.txt"
  content  = "Block A, row 1, seat 10\n"
}

resource "local_file" "seat_a_2_01" {
  filename = "${path.module}/seats/a-2-01.txt"
  content  = "Block A, row 2, seat 01\n"
}

resource "local_file" "seat_a_2_02" {
  filename = "${path.module}/seats/a-2-02.txt"
  content  = "Block A, row 2, seat 02\n"
}

resource "local_file" "seat_a_2_03" {
  filename = "${path.module}/seats/a-2-03.txt"
  content  = "Block A, row 2, seat 03\n"
}

resource "local_file" "seat_a_2_04" {
  filename = "${path.module}/seats/a-2-04.txt"
  content  = "Block A, row 2, seat 04\n"
}

resource "local_file" "seat_a_2_05" {
  filename = "${path.module}/seats/a-2-05.txt"
  content  = "Block A, row 2, seat 05\n"
}

resource "local_file" "seat_a_2_06" {
  filename = "${path.module}/seats/a-2-06.txt"
  content  = "Block A, row 2, seat 06\n"
}

resource "local_file" "seat_a_2_07" {
  filename = "${path.module}/seats/a-2-07.txt"
  content  = "Block A, row 2, seat 07\n"
}

resource "local_file" "seat_a_2_08" {
  filename = "${path.module}/seats/a-2-08.txt"
  content  = "Block A, row 2, seat 08\n"
}

resource "local_file" "seat_a_2_09" {
  filename = "${path.module}/seats/a-2-09.txt"
  content  = "Block A, row 2, seat 09\n"
}

resource "local_file" "seat_a_2_10" {
  filename = "${path.module}/seats/a-2-10.txt"
  content  = "Block A, row 2, seat 10\n"
}

resource "local_file" "seat_a_3_01" {
  filename = "${path.module}/seats/a-3-01.txt"
  content  = "Block A, row 3, seat 01\n"
}

resource "local_file" "seat_a_3_02" {
  filename = "${path.module}/seats/a-3-02.txt"
  content  = "Block A, row 3, seat 02\n"
}

resource "local_file" "seat_a_3_03" {
  filename = "${path.module}/seats/a-3-03.txt"
  content  = "Block A, row 3, seat 03\n"
}

resource "local_file" "seat_a_3_04" {
  filename = "${path.module}/seats/a-3-04.txt"
  content  = "Block A, row 3, seat 04\n"
}

resource "local_file" "seat_a_3_05" {
  filename = "${path.module}/seats/a-3-05.txt"
  content  = "Block A, row 3, seat 05\n"
}

resource "local_file" "seat_a_3_06" {
  filename = "${path.module}/seats/a-3-06.txt"
  content  = "Block A, row 3, seat 06\n"
}

resource "local_file" "seat_a_3_07" {
  filename = "${path.module}/seats/a-3-07.txt"
  content  = "Block A, row 3, seat 07\n"
}

resource "local_file" "seat_a_3_08" {
  filename = "${path.module}/seats/a-3-08.txt"
  content  = "Block A, row 3, seat 08\n"
}

resource "local_file" "seat_a_3_09" {
  filename = "${path.module}/seats/a-3-09.txt"
  content  = "Block A, row 3, seat 09\n"
}

resource "local_file" "seat_a_3_10" {
  filename = "${path.module}/seats/a-3-10.txt"
  content  = "Block A, row 3, seat 10\n"
}

resource "local_file" "seat_a_4_01" {
  filename = "${path.module}/seats/a-4-01.txt"
  content  = "Block A, row 4, seat 01\n"
}

resource "local_file" "seat_a_4_02" {
  filename = "${path.module}/seats/a-4-02.txt"
  content  = "Block A, row 4, seat 02\n"
}

resource "local_file" "seat_a_4_03" {
  filename = "${path.module}/seats/a-4-03.txt"
  content  = "Block A, row 4, seat 03\n"
}

resource "local_file" "seat_a_4_04" {
  filename = "${path.module}/seats/a-4-04.txt"
  content  = "Block A, row 4, seat 04\n"
}

resource "local_file" "seat_a_4_05" {
  filename = "${path.module}/seats/a-4-05.txt"
  content  = "Block A, row 4, seat 05\n"
}

resource "local_file" "seat_a_4_06" {
  filename = "${path.module}/seats/a-4-06.txt"
  content  = "Block A, row 4, seat 06\n"
}

resource "local_file" "seat_a_4_07" {
  filename = "${path.module}/seats/a-4-07.txt"
  content  = "Block A, row 4, seat 07\n"
}

resource "local_file" "seat_a_4_08" {
  filename = "${path.module}/seats/a-4-08.txt"
  content  = "Block A, row 4, seat 08\n"
}

resource "local_file" "seat_a_4_09" {
  filename = "${path.module}/seats/a-4-09.txt"
  content  = "Block A, row 4, seat 09\n"
}

resource "local_file" "seat_a_4_10" {
  filename = "${path.module}/seats/a-4-10.txt"
  content  = "Block A, row 4, seat 10\n"
}

resource "local_file" "seat_a_5_01" {
  filename = "${path.module}/seats/a-5-01.txt"
  content  = "Block A, row 5, seat 01\n"
}

resource "local_file" "seat_a_5_02" {
  filename = "${path.module}/seats/a-5-02.txt"
  content  = "Block A, row 5, seat 02\n"
}

resource "local_file" "seat_a_5_03" {
  filename = "${path.module}/seats/a-5-03.txt"
  content  = "Block A, row 5, seat 03\n"
}

resource "local_file" "seat_a_5_04" {
  filename = "${path.module}/seats/a-5-04.txt"
  content  = "Block A, row 5, seat 04\n"
}

resource "local_file" "seat_a_5_05" {
  filename = "${path.module}/seats/a-5-05.txt"
  content  = "Block A, row 5, seat 05\n"
}

resource "local_file" "seat_a_5_06" {
  filename = "${path.module}/seats/a-5-06.txt"
  content  = "Block A, row 5, seat 06\n"
}

resource "local_file" "seat_a_5_07" {
  filename = "${path.module}/seats/a-5-07.txt"
  content  = "Block A, row 5, seat 07\n"
}

resource "local_file" "seat_a_5_08" {
  filename = "${path.module}/seats/a-5-08.txt"
  content  = "Block A, row 5, seat 08\n"
}

resource "local_file" "seat_a_5_09" {
  filename = "${path.module}/seats/a-5-09.txt"
  content  = "Block A, row 5, seat 09\n"
}

resource "local_file" "seat_a_5_10" {
  filename = "${path.module}/seats/a-5-10.txt"
  content  = "Block A, row 5, seat 10\n"
}

resource "local_file" "seat_b_1_01" {
  filename = "${path.module}/seats/b-1-01.txt"
  content  = "Block B, row 1, seat 01\n"
}

resource "local_file" "seat_b_1_02" {
  filename = "${path.module}/seats/b-1-02.txt"
  content  = "Block B, row 1, seat 02\n"
}

resource "local_file" "seat_b_1_03" {
  filename = "${path.module}/seats/b-1-03.txt"
  content  = "Block B, row 1, seat 03\n"
}

resource "local_file" "seat_b_1_04" {
  filename = "${path.module}/seats/b-1-04.txt"
  content  = "Block B, row 1, seat 04\n"
}

resource "local_file" "seat_b_1_05" {
  filename = "${path.module}/seats/b-1-05.txt"
  content  = "Block B, row 1, seat 05\n"
}

resource "local_file" "seat_b_1_06" {
  filename = "${path.module}/seats/b-1-06.txt"
  content  = "Block B, row 1, seat 06\n"
}

resource "local_file" "seat_b_1_07" {
  filename = "${path.module}/seats/b-1-07.txt"
  content  = "Block B, row 1, seat 07\n"
}

resource "local_file" "seat_b_1_08" {
  filename = "${path.module}/seats/b-1-08.txt"
  content  = "Block B, row 1, seat 08\n"
}

resource "local_file" "seat_b_1_09" {
  filename = "${path.module}/seats/b-1-09.txt"
  content  = "Block B, row 1, seat 09\n"
}

resource "local_file" "seat_b_1_10" {
  filename = "${path.module}/seats/b-1-10.txt"
  content  = "Block B, row 1, seat 10\n"
}

resource "local_file" "seat_b_2_01" {
  filename = "${path.module}/seats/b-2-01.txt"
  content  = "Block B, row 2, seat 01\n"
}

resource "local_file" "seat_b_2_02" {
  filename = "${path.module}/seats/b-2-02.txt"
  content  = "Block B, row 2, seat 02\n"
}

resource "local_file" "seat_b_2_03" {
  filename = "${path.module}/seats/b-2-03.txt"
  content  = "Block B, row 2, seat 03\n"
}

resource "local_file" "seat_b_2_04" {
  filename = "${path.module}/seats/b-2-04.txt"
  content  = "Block B, row 2, seat 04\n"
}

resource "local_file" "seat_b_2_05" {
  filename = "${path.module}/seats/b-2-05.txt"
  content  = "Block B, row 2, seat 05\n"
}

resource "local_file" "seat_b_2_06" {
  filename = "${path.module}/seats/b-2-06.txt"
  content  = "Block B, row 2, seat 06\n"
}

resource "local_file" "seat_b_2_07" {
  filename = "${path.module}/seats/b-2-07.txt"
  content  = "Block B, row 2, seat 07\n"
}

resource "local_file" "seat_b_2_08" {
  filename = "${path.module}/seats/b-2-08.txt"
  content  = "Block B, row 2, seat 08\n"
}

resource "local_file" "seat_b_2_09" {
  filename = "${path.module}/seats/b-2-09.txt"
  content  = "Block B, row 2, seat 09\n"
}

resource "local_file" "seat_b_2_10" {
  filename = "${path.module}/seats/b-2-10.txt"
  content  = "Block B, row 2, seat 10\n"
}

resource "local_file" "seat_b_3_01" {
  filename = "${path.module}/seats/b-3-01.txt"
  content  = "Block B, row 3, seat 01\n"
}

resource "local_file" "seat_b_3_02" {
  filename = "${path.module}/seats/b-3-02.txt"
  content  = "Block B, row 3, seat 02\n"
}

resource "local_file" "seat_b_3_03" {
  filename = "${path.module}/seats/b-3-03.txt"
  content  = "Block B, row 3, seat 03\n"
}

resource "local_file" "seat_b_3_04" {
  filename = "${path.module}/seats/b-3-04.txt"
  content  = "Block B, row 3, seat 04\n"
}

resource "local_file" "seat_b_3_05" {
  filename = "${path.module}/seats/b-3-05.txt"
  content  = "Block B, row 3, seat 05\n"
}

resource "local_file" "seat_b_3_06" {
  filename = "${path.module}/seats/b-3-06.txt"
  content  = "Block B, row 3, seat 06\n"
}

resource "local_file" "seat_b_3_07" {
  filename = "${path.module}/seats/b-3-07.txt"
  content  = "Block B, row 3, seat 07\n"
}

resource "local_file" "seat_b_3_08" {
  filename = "${path.module}/seats/b-3-08.txt"
  content  = "Block B, row 3, seat 08\n"
}

resource "local_file" "seat_b_3_09" {
  filename = "${path.module}/seats/b-3-09.txt"
  content  = "Block B, row 3, seat 09\n"
}

resource "local_file" "seat_b_3_10" {
  filename = "${path.module}/seats/b-3-10.txt"
  content  = "Block B, row 3, seat 10\n"
}

resource "local_file" "seat_b_4_01" {
  filename = "${path.module}/seats/b-4-01.txt"
  content  = "Block B, row 4, seat 01\n"
}

resource "local_file" "seat_b_4_02" {
  filename = "${path.module}/seats/b-4-02.txt"
  content  = "Block B, row 4, seat 02\n"
}

resource "local_file" "seat_b_4_03" {
  filename = "${path.module}/seats/b-4-03.txt"
  content  = "Block B, row 4, seat 03\n"
}

resource "local_file" "seat_b_4_04" {
  filename = "${path.module}/seats/b-4-04.txt"
  content  = "Block B, row 4, seat 04\n"
}

resource "local_file" "seat_b_4_05" {
  filename = "${path.module}/seats/b-4-05.txt"
  content  = "Block B, row 4, seat 05\n"
}

resource "local_file" "seat_b_4_06" {
  filename = "${path.module}/seats/b-4-06.txt"
  content  = "Block B, row 4, seat 06\n"
}

resource "local_file" "seat_b_4_07" {
  filename = "${path.module}/seats/b-4-07.txt"
  content  = "Block B, row 4, seat 07\n"
}

resource "local_file" "seat_b_4_08" {
  filename = "${path.module}/seats/b-4-08.txt"
  content  = "Block B, row 4, seat 08\n"
}

resource "local_file" "seat_b_4_09" {
  filename = "${path.module}/seats/b-4-09.txt"
  content  = "Block B, row 4, seat 09\n"
}

resource "local_file" "seat_b_4_10" {
  filename = "${path.module}/seats/b-4-10.txt"
  content  = "Block B, row 4, seat 10\n"
}

resource "local_file" "seat_b_5_01" {
  filename = "${path.module}/seats/b-5-01.txt"
  content  = "Block B, row 5, seat 01\n"
}

resource "local_file" "seat_b_5_02" {
  filename = "${path.module}/seats/b-5-02.txt"
  content  = "Block B, row 5, seat 02\n"
}

resource "local_file" "seat_b_5_03" {
  filename = "${path.module}/seats/b-5-03.txt"
  content  = "Block B, row 5, seat 03\n"
}

resource "local_file" "seat_b_5_04" {
  filename = "${path.module}/seats/b-5-04.txt"
  content  = "Block B, row 5, seat 04\n"
}

resource "local_file" "seat_b_5_05" {
  filename = "${path.module}/seats/b-5-05.txt"
  content  = "Block B, row 5, seat 05\n"
}

resource "local_file" "seat_b_5_06" {
  filename = "${path.module}/seats/b-5-06.txt"
  content  = "Block B, row 5, seat 06\n"
}

resource "local_file" "seat_b_5_07" {
  filename = "${path.module}/seats/b-5-07.txt"
  content  = "Block B, row 5, seat 07\n"
}

resource "local_file" "seat_b_5_08" {
  filename = "${path.module}/seats/b-5-08.txt"
  content  = "Block B, row 5, seat 08\n"
}

resource "local_file" "seat_b_5_09" {
  filename = "${path.module}/seats/b-5-09.txt"
  content  = "Block B, row 5, seat 09\n"
}

resource "local_file" "seat_b_5_10" {
  filename = "${path.module}/seats/b-5-10.txt"
  content  = "Block B, row 5, seat 10\n"
}

resource "local_file" "seat_c_1_01" {
  filename = "${path.module}/seats/c-1-01.txt"
  content  = "Block C, row 1, seat 01\n"
}

resource "local_file" "seat_c_1_02" {
  filename = "${path.module}/seats/c-1-02.txt"
  content  = "Block C, row 1, seat 02\n"
}

resource "local_file" "seat_c_1_03" {
  filename = "${path.module}/seats/c-1-03.txt"
  content  = "Block C, row 1, seat 03\n"
}

resource "local_file" "seat_c_1_04" {
  filename = "${path.module}/seats/c-1-04.txt"
  content  = "Block C, row 1, seat 04\n"
}

resource "local_file" "seat_c_1_05" {
  filename = "${path.module}/seats/c-1-05.txt"
  content  = "Block C, row 1, seat 05\n"
}

resource "local_file" "seat_c_1_06" {
  filename = "${path.module}/seats/c-1-06.txt"
  content  = "Block C, row 1, seat 06\n"
}

resource "local_file" "seat_c_1_07" {
  filename = "${path.module}/seats/c-1-07.txt"
  content  = "Block C, row 1, seat 07\n"
}

resource "local_file" "seat_c_1_08" {
  filename = "${path.module}/seats/c-1-08.txt"
  content  = "Block C, row 1, seat 08\n"
}

resource "local_file" "seat_c_1_09" {
  filename = "${path.module}/seats/c-1-09.txt"
  content  = "Block C, row 1, seat 09\n"
}

resource "local_file" "seat_c_1_10" {
  filename = "${path.module}/seats/c-1-10.txt"
  content  = "Block C, row 1, seat 10\n"
}

resource "local_file" "seat_c_2_01" {
  filename = "${path.module}/seats/c-2-01.txt"
  content  = "Block C, row 2, seat 01\n"
}

resource "local_file" "seat_c_2_02" {
  filename = "${path.module}/seats/c-2-02.txt"
  content  = "Block C, row 2, seat 02\n"
}

resource "local_file" "seat_c_2_03" {
  filename = "${path.module}/seats/c-2-03.txt"
  content  = "Block C, row 2, seat 03\n"
}

resource "local_file" "seat_c_2_04" {
  filename = "${path.module}/seats/c-2-04.txt"
  content  = "Block C, row 2, seat 04\n"
}

resource "local_file" "seat_c_2_05" {
  filename = "${path.module}/seats/c-2-05.txt"
  content  = "Block C, row 2, seat 05\n"
}

resource "local_file" "seat_c_2_06" {
  filename = "${path.module}/seats/c-2-06.txt"
  content  = "Block C, row 2, seat 06\n"
}

resource "local_file" "seat_c_2_07" {
  filename = "${path.module}/seats/c-2-07.txt"
  content  = "Block C, row 2, seat 07\n"
}

resource "local_file" "seat_c_2_08" {
  filename = "${path.module}/seats/c-2-08.txt"
  content  = "Block C, row 2, seat 08\n"
}

resource "local_file" "seat_c_2_09" {
  filename = "${path.module}/seats/c-2-09.txt"
  content  = "Block C, row 2, seat 09\n"
}

resource "local_file" "seat_c_2_10" {
  filename = "${path.module}/seats/c-2-10.txt"
  content  = "Block C, row 2, seat 10\n"
}

resource "local_file" "seat_c_3_01" {
  filename = "${path.module}/seats/c-3-01.txt"
  content  = "Block C, row 3, seat 01\n"
}

resource "local_file" "seat_c_3_02" {
  filename = "${path.module}/seats/c-3-02.txt"
  content  = "Block C, row 3, seat 02\n"
}

resource "local_file" "seat_c_3_03" {
  filename = "${path.module}/seats/c-3-03.txt"
  content  = "Block C, row 3, seat 03\n"
}

resource "local_file" "seat_c_3_04" {
  filename = "${path.module}/seats/c-3-04.txt"
  content  = "Block C, row 3, seat 04\n"
}

resource "local_file" "seat_c_3_05" {
  filename = "${path.module}/seats/c-3-05.txt"
  content  = "Block C, row 3, seat 05\n"
}

resource "local_file" "seat_c_3_06" {
  filename = "${path.module}/seats/c-3-06.txt"
  content  = "Block C, row 3, seat 06\n"
}

resource "local_file" "seat_c_3_07" {
  filename = "${path.module}/seats/c-3-07.txt"
  content  = "Block C, row 3, seat 07\n"
}

resource "local_file" "seat_c_3_08" {
  filename = "${path.module}/seats/c-3-08.txt"
  content  = "Block C, row 3, seat 08\n"
}

resource "local_file" "seat_c_3_09" {
  filename = "${path.module}/seats/c-3-09.txt"
  content  = "Block C, row 3, seat 09\n"
}

resource "local_file" "seat_c_3_10" {
  filename = "${path.module}/seats/c-3-10.txt"
  content  = "Block C, row 3, seat 10\n"
}

resource "local_file" "seat_c_4_01" {
  filename = "${path.module}/seats/c-4-01.txt"
  content  = "Block C, row 4, seat 01\n"
}

resource "local_file" "seat_c_4_02" {
  filename = "${path.module}/seats/c-4-02.txt"
  content  = "Block C, row 4, seat 02\n"
}

resource "local_file" "seat_c_4_03" {
  filename = "${path.module}/seats/c-4-03.txt"
  content  = "Block C, row 4, seat 03\n"
}

resource "local_file" "seat_c_4_04" {
  filename = "${path.module}/seats/c-4-04.txt"
  content  = "Block C, row 4, seat 04\n"
}

resource "local_file" "seat_c_4_05" {
  filename = "${path.module}/seats/c-4-05.txt"
  content  = "Block C, row 4, seat 05\n"
}

resource "local_file" "seat_c_4_06" {
  filename = "${path.module}/seats/c-4-06.txt"
  content  = "Block C, row 4, seat 06\n"
}

resource "local_file" "seat_c_4_07" {
  filename = "${path.module}/seats/c-4-07.txt"
  content  = "Block C, row 4, seat 07\n"
}

resource "local_file" "seat_c_4_08" {
  filename = "${path.module}/seats/c-4-08.txt"
  content  = "Block C, row 4, seat 08\n"
}

resource "local_file" "seat_c_4_09" {
  filename = "${path.module}/seats/c-4-09.txt"
  content  = "Block C, row 4, seat 09\n"
}

resource "local_file" "seat_c_4_10" {
  filename = "${path.module}/seats/c-4-10.txt"
  content  = "Block C, row 4, seat 10\n"
}

resource "local_file" "seat_c_5_01" {
  filename = "${path.module}/seats/c-5-01.txt"
  content  = "Block C, row 5, seat 01\n"
}

resource "local_file" "seat_c_5_02" {
  filename = "${path.module}/seats/c-5-02.txt"
  content  = "Block C, row 5, seat 02\n"
}

resource "local_file" "seat_c_5_03" {
  filename = "${path.module}/seats/c-5-03.txt"
  content  = "Block C, row 5, seat 03\n"
}

resource "local_file" "seat_c_5_04" {
  filename = "${path.module}/seats/c-5-04.txt"
  content  = "Block C, row 5, seat 04\n"
}

resource "local_file" "seat_c_5_05" {
  filename = "${path.module}/seats/c-5-05.txt"
  content  = "Block C, row 5, seat 05\n"
}

resource "local_file" "seat_c_5_06" {
  filename = "${path.module}/seats/c-5-06.txt"
  content  = "Block C, row 5, seat 06\n"
}

resource "local_file" "seat_c_5_07" {
  filename = "${path.module}/seats/c-5-07.txt"
  content  = "Block C, row 5, seat 07\n"
}

resource "local_file" "seat_c_5_08" {
  filename = "${path.module}/seats/c-5-08.txt"
  content  = "Block C, row 5, seat 08\n"
}

resource "local_file" "seat_c_5_09" {
  filename = "${path.module}/seats/c-5-09.txt"
  content  = "Block C, row 5, seat 09\n"
}

resource "local_file" "seat_c_5_10" {
  filename = "${path.module}/seats/c-5-10.txt"
  content  = "Block C, row 5, seat 10\n"
}

resource "local_file" "seat_d_1_01" {
  filename = "${path.module}/seats/d-1-01.txt"
  content  = "Block D, row 1, seat 01\n"
}

resource "local_file" "seat_d_1_02" {
  filename = "${path.module}/seats/d-1-02.txt"
  content  = "Block D, row 1, seat 02\n"
}

resource "local_file" "seat_d_1_03" {
  filename = "${path.module}/seats/d-1-03.txt"
  content  = "Block D, row 1, seat 03\n"
}

resource "local_file" "seat_d_1_04" {
  filename = "${path.module}/seats/d-1-04.txt"
  content  = "Block D, row 1, seat 04\n"
}

resource "local_file" "seat_d_1_05" {
  filename = "${path.module}/seats/d-1-05.txt"
  content  = "Block D, row 1, seat 05\n"
}

resource "local_file" "seat_d_1_06" {
  filename = "${path.module}/seats/d-1-06.txt"
  content  = "Block D, row 1, seat 06\n"
}

resource "local_file" "seat_d_1_07" {
  filename = "${path.module}/seats/d-1-07.txt"
  content  = "Block D, row 1, seat 07\n"
}

resource "local_file" "seat_d_1_08" {
  filename = "${path.module}/seats/d-1-08.txt"
  content  = "Block D, row 1, seat 08\n"
}

resource "local_file" "seat_d_1_09" {
  filename = "${path.module}/seats/d-1-09.txt"
  content  = "Block D, row 1, seat 09\n"
}

resource "local_file" "seat_d_1_10" {
  filename = "${path.module}/seats/d-1-10.txt"
  content  = "Block D, row 1, seat 10\n"
}

resource "local_file" "seat_d_2_01" {
  filename = "${path.module}/seats/d-2-01.txt"
  content  = "Block D, row 2, seat 01\n"
}

resource "local_file" "seat_d_2_02" {
  filename = "${path.module}/seats/d-2-02.txt"
  content  = "Block D, row 2, seat 02\n"
}

resource "local_file" "seat_d_2_03" {
  filename = "${path.module}/seats/d-2-03.txt"
  content  = "Block D, row 2, seat 03\n"
}

resource "local_file" "seat_d_2_04" {
  filename = "${path.module}/seats/d-2-04.txt"
  content  = "Block D, row 2, seat 04\n"
}

resource "local_file" "seat_d_2_05" {
  filename = "${path.module}/seats/d-2-05.txt"
  content  = "Block D, row 2, seat 05\n"
}

resource "local_file" "seat_d_2_06" {
  filename = "${path.module}/seats/d-2-06.txt"
  content  = "Block D, row 2, seat 06\n"
}

resource "local_file" "seat_d_2_07" {
  filename = "${path.module}/seats/d-2-07.txt"
  content  = "Block D, row 2, seat 07\n"
}

resource "local_file" "seat_d_2_08" {
  filename = "${path.module}/seats/d-2-08.txt"
  content  = "Block D, row 2, seat 08\n"
}

resource "local_file" "seat_d_2_09" {
  filename = "${path.module}/seats/d-2-09.txt"
  content  = "Block D, row 2, seat 09\n"
}

resource "local_file" "seat_d_2_10" {
  filename = "${path.module}/seats/d-2-10.txt"
  content  = "Block D, row 2, seat 10\n"
}

resource "local_file" "seat_d_3_01" {
  filename = "${path.module}/seats/d-3-01.txt"
  content  = "Block D, row 3, seat 01\n"
}

resource "local_file" "seat_d_3_02" {
  filename = "${path.module}/seats/d-3-02.txt"
  content  = "Block D, row 3, seat 02\n"
}

resource "local_file" "seat_d_3_03" {
  filename = "${path.module}/seats/d-3-03.txt"
  content  = "Block D, row 3, seat 03\n"
}

resource "local_file" "seat_d_3_04" {
  filename = "${path.module}/seats/d-3-04.txt"
  content  = "Block D, row 3, seat 04\n"
}

resource "local_file" "seat_d_3_05" {
  filename = "${path.module}/seats/d-3-05.txt"
  content  = "Block D, row 3, seat 05\n"
}

resource "local_file" "seat_d_3_06" {
  filename = "${path.module}/seats/d-3-06.txt"
  content  = "Block D, row 3, seat 06\n"
}

resource "local_file" "seat_d_3_07" {
  filename = "${path.module}/seats/d-3-07.txt"
  content  = "Block D, row 3, seat 07\n"
}

resource "local_file" "seat_d_3_08" {
  filename = "${path.module}/seats/d-3-08.txt"
  content  = "Block D, row 3, seat 08\n"
}

resource "local_file" "seat_d_3_09" {
  filename = "${path.module}/seats/d-3-09.txt"
  content  = "Block D, row 3, seat 09\n"
}

resource "local_file" "seat_d_3_10" {
  filename = "${path.module}/seats/d-3-10.txt"
  content  = "Block D, row 3, seat 10\n"
}

resource "local_file" "seat_d_4_01" {
  filename = "${path.module}/seats/d-4-01.txt"
  content  = "Block D, row 4, seat 01\n"
}

resource "local_file" "seat_d_4_02" {
  filename = "${path.module}/seats/d-4-02.txt"
  content  = "Block D, row 4, seat 02\n"
}

resource "local_file" "seat_d_4_03" {
  filename = "${path.module}/seats/d-4-03.txt"
  content  = "Block D, row 4, seat 03\n"
}

resource "local_file" "seat_d_4_04" {
  filename = "${path.module}/seats/d-4-04.txt"
  content  = "Block D, row 4, seat 04\n"
}

resource "local_file" "seat_d_4_05" {
  filename = "${path.module}/seats/d-4-05.txt"
  content  = "Block D, row 4, seat 05\n"
}

resource "local_file" "seat_d_4_06" {
  filename = "${path.module}/seats/d-4-06.txt"
  content  = "Block D, row 4, seat 06\n"
}

resource "local_file" "seat_d_4_07" {
  filename = "${path.module}/seats/d-4-07.txt"
  content  = "Block D, row 4, seat 07\n"
}

resource "local_file" "seat_d_4_08" {
  filename = "${path.module}/seats/d-4-08.txt"
  content  = "Block D, row 4, seat 08\n"
}

resource "local_file" "seat_d_4_09" {
  filename = "${path.module}/seats/d-4-09.txt"
  content  = "Block D, row 4, seat 09\n"
}

resource "local_file" "seat_d_4_10" {
  filename = "${path.module}/seats/d-4-10.txt"
  content  = "Block D, row 4, seat 10\n"
}

resource "local_file" "seat_d_5_01" {
  filename = "${path.module}/seats/d-5-01.txt"
  content  = "Block D, row 5, seat 01\n"
}

resource "local_file" "seat_d_5_02" {
  filename = "${path.module}/seats/d-5-02.txt"
  content  = "Block D, row 5, seat 02\n"
}

resource "local_file" "seat_d_5_03" {
  filename = "${path.module}/seats/d-5-03.txt"
  content  = "Block D, row 5, seat 03\n"
}

resource "local_file" "seat_d_5_04" {
  filename = "${path.module}/seats/d-5-04.txt"
  content  = "Block D, row 5, seat 04\n"
}

resource "local_file" "seat_d_5_05" {
  filename = "${path.module}/seats/d-5-05.txt"
  content  = "Block D, row 5, seat 05\n"
}

resource "local_file" "seat_d_5_06" {
  filename = "${path.module}/seats/d-5-06.txt"
  content  = "Block D, row 5, seat 06\n"
}

resource "local_file" "seat_d_5_07" {
  filename = "${path.module}/seats/d-5-07.txt"
  content  = "Block D, row 5, seat 07\n"
}

resource "local_file" "seat_d_5_08" {
  filename = "${path.module}/seats/d-5-08.txt"
  content  = "Block D, row 5, seat 08\n"
}

resource "local_file" "seat_d_5_09" {
  filename = "${path.module}/seats/d-5-09.txt"
  content  = "Block D, row 5, seat 09\n"
}

resource "local_file" "seat_d_5_10" {
  filename = "${path.module}/seats/d-5-10.txt"
  content  = "Block D, row 5, seat 10\n"
}

resource "local_file" "seat_e_1_01" {
  filename = "${path.module}/seats/e-1-01.txt"
  content  = "Block E, row 1, seat 01\n"
}

resource "local_file" "seat_e_1_02" {
  filename = "${path.module}/seats/e-1-02.txt"
  content  = "Block E, row 1, seat 02\n"
}

resource "local_file" "seat_e_1_03" {
  filename = "${path.module}/seats/e-1-03.txt"
  content  = "Block E, row 1, seat 03\n"
}

resource "local_file" "seat_e_1_04" {
  filename = "${path.module}/seats/e-1-04.txt"
  content  = "Block E, row 1, seat 04\n"
}

resource "local_file" "seat_e_1_05" {
  filename = "${path.module}/seats/e-1-05.txt"
  content  = "Block E, row 1, seat 05\n"
}

resource "local_file" "seat_e_1_06" {
  filename = "${path.module}/seats/e-1-06.txt"
  content  = "Block E, row 1, seat 06\n"
}

resource "local_file" "seat_e_1_07" {
  filename = "${path.module}/seats/e-1-07.txt"
  content  = "Block E, row 1, seat 07\n"
}

resource "local_file" "seat_e_1_08" {
  filename = "${path.module}/seats/e-1-08.txt"
  content  = "Block E, row 1, seat 08\n"
}

resource "local_file" "seat_e_1_09" {
  filename = "${path.module}/seats/e-1-09.txt"
  content  = "Block E, row 1, seat 09\n"
}

resource "local_file" "seat_e_1_10" {
  filename = "${path.module}/seats/e-1-10.txt"
  content  = "Block E, row 1, seat 10\n"
}

resource "local_file" "seat_e_2_01" {
  filename = "${path.module}/seats/e-2-01.txt"
  content  = "Block E, row 2, seat 01\n"
}

resource "local_file" "seat_e_2_02" {
  filename = "${path.module}/seats/e-2-02.txt"
  content  = "Block E, row 2, seat 02\n"
}

resource "local_file" "seat_e_2_03" {
  filename = "${path.module}/seats/e-2-03.txt"
  content  = "Block E, row 2, seat 03\n"
}

resource "local_file" "seat_e_2_04" {
  filename = "${path.module}/seats/e-2-04.txt"
  content  = "Block E, row 2, seat 04\n"
}

resource "local_file" "seat_e_2_05" {
  filename = "${path.module}/seats/e-2-05.txt"
  content  = "Block E, row 2, seat 05\n"
}

resource "local_file" "seat_e_2_06" {
  filename = "${path.module}/seats/e-2-06.txt"
  content  = "Block E, row 2, seat 06\n"
}

resource "local_file" "seat_e_2_07" {
  filename = "${path.module}/seats/e-2-07.txt"
  content  = "Block E, row 2, seat 07\n"
}

resource "local_file" "seat_e_2_08" {
  filename = "${path.module}/seats/e-2-08.txt"
  content  = "Block E, row 2, seat 08\n"
}

resource "local_file" "seat_e_2_09" {
  filename = "${path.module}/seats/e-2-09.txt"
  content  = "Block E, row 2, seat 09\n"
}

resource "local_file" "seat_e_2_10" {
  filename = "${path.module}/seats/e-2-10.txt"
  content  = "Block E, row 2, seat 10\n"
}

resource "local_file" "seat_e_3_01" {
  filename = "${path.module}/seats/e-3-01.txt"
  content  = "Block E, row 3, seat 01\n"
}

resource "local_file" "seat_e_3_02" {
  filename = "${path.module}/seats/e-3-02.txt"
  content  = "Block E, row 3, seat 02\n"
}

resource "local_file" "seat_e_3_03" {
  filename = "${path.module}/seats/e-3-03.txt"
  content  = "Block E, row 3, seat 03\n"
}

resource "local_file" "seat_e_3_04" {
  filename = "${path.module}/seats/e-3-04.txt"
  content  = "Block E, row 3, seat 04\n"
}

resource "local_file" "seat_e_3_05" {
  filename = "${path.module}/seats/e-3-05.txt"
  content  = "Block E, row 3, seat 05\n"
}

resource "local_file" "seat_e_3_06" {
  filename = "${path.module}/seats/e-3-06.txt"
  content  = "Block E, row 3, seat 06\n"
}

resource "local_file" "seat_e_3_07" {
  filename = "${path.module}/seats/e-3-07.txt"
  content  = "Block E, row 3, seat 07\n"
}

resource "local_file" "seat_e_3_08" {
  filename = "${path.module}/seats/e-3-08.txt"
  content  = "Block E, row 3, seat 08\n"
}

resource "local_file" "seat_e_3_09" {
  filename = "${path.module}/seats/e-3-09.txt"
  content  = "Block E, row 3, seat 09\n"
}

resource "local_file" "seat_e_3_10" {
  filename = "${path.module}/seats/e-3-10.txt"
  content  = "Block E, row 3, seat 10\n"
}

resource "local_file" "seat_e_4_01" {
  filename = "${path.module}/seats/e-4-01.txt"
  content  = "Block E, row 4, seat 01\n"
}

resource "local_file" "seat_e_4_02" {
  filename = "${path.module}/seats/e-4-02.txt"
  content  = "Block E, row 4, seat 02\n"
}

resource "local_file" "seat_e_4_03" {
  filename = "${path.module}/seats/e-4-03.txt"
  content  = "Block E, row 4, seat 03\n"
}

resource "local_file" "seat_e_4_04" {
  filename = "${path.module}/seats/e-4-04.txt"
  content  = "Block E, row 4, seat 04\n"
}

resource "local_file" "seat_e_4_05" {
  filename = "${path.module}/seats/e-4-05.txt"
  content  = "Block E, row 4, seat 05\n"
}

resource "local_file" "seat_e_4_06" {
  filename = "${path.module}/seats/e-4-06.txt"
  content  = "Block E, row 4, seat 06\n"
}

resource "local_file" "seat_e_4_07" {
  filename = "${path.module}/seats/e-4-07.txt"
  content  = "Block E, row 4, seat 07\n"
}

resource "local_file" "seat_e_4_08" {
  filename = "${path.module}/seats/e-4-08.txt"
  content  = "Block E, row 4, seat 08\n"
}

resource "local_file" "seat_e_4_09" {
  filename = "${path.module}/seats/e-4-09.txt"
  content  = "Block E, row 4, seat 09\n"
}

resource "local_file" "seat_e_4_10" {
  filename = "${path.module}/seats/e-4-10.txt"
  content  = "Block E, row 4, seat 10\n"
}

resource "local_file" "seat_e_5_01" {
  filename = "${path.module}/seats/e-5-01.txt"
  content  = "Block E, row 5, seat 01\n"
}

resource "local_file" "seat_e_5_02" {
  filename = "${path.module}/seats/e-5-02.txt"
  content  = "Block E, row 5, seat 02\n"
}

resource "local_file" "seat_e_5_03" {
  filename = "${path.module}/seats/e-5-03.txt"
  content  = "Block E, row 5, seat 03\n"
}

resource "local_file" "seat_e_5_04" {
  filename = "${path.module}/seats/e-5-04.txt"
  content  = "Block E, row 5, seat 04\n"
}

resource "local_file" "seat_e_5_05" {
  filename = "${path.module}/seats/e-5-05.txt"
  content  = "Block E, row 5, seat 05\n"
}

resource "local_file" "seat_e_5_06" {
  filename = "${path.module}/seats/e-5-06.txt"
  content  = "Block E, row 5, seat 06\n"
}

resource "local_file" "seat_e_5_07" {
  filename = "${path.module}/seats/e-5-07.txt"
  content  = "Block E, row 5, seat 07\n"
}

resource "local_file" "seat_e_5_08" {
  filename = "${path.module}/seats/e-5-08.txt"
  content  = "Block E, row 5, seat 08\n"
}

resource "local_file" "seat_e_5_09" {
  filename = "${path.module}/seats/e-5-09.txt"
  content  = "Block E, row 5, seat 09\n"
}

resource "local_file" "seat_e_5_10" {
  filename = "${path.module}/seats/e-5-10.txt"
  content  = "Block E, row 5, seat 10\n"
}

resource "local_file" "seat_f_1_01" {
  filename = "${path.module}/seats/f-1-01.txt"
  content  = "Block F, row 1, seat 01\n"
}

resource "local_file" "seat_f_1_02" {
  filename = "${path.module}/seats/f-1-02.txt"
  content  = "Block F, row 1, seat 02\n"
}

resource "local_file" "seat_f_1_03" {
  filename = "${path.module}/seats/f-1-03.txt"
  content  = "Block F, row 1, seat 03\n"
}

resource "local_file" "seat_f_1_04" {
  filename = "${path.module}/seats/f-1-04.txt"
  content  = "Block F, row 1, seat 04\n"
}

resource "local_file" "seat_f_1_05" {
  filename = "${path.module}/seats/f-1-05.txt"
  content  = "Block F, row 1, seat 05\n"
}

resource "local_file" "seat_f_1_06" {
  filename = "${path.module}/seats/f-1-06.txt"
  content  = "Block F, row 1, seat 06\n"
}

resource "local_file" "seat_f_1_07" {
  filename = "${path.module}/seats/f-1-07.txt"
  content  = "Block F, row 1, seat 07\n"
}

resource "local_file" "seat_f_1_08" {
  filename = "${path.module}/seats/f-1-08.txt"
  content  = "Block F, row 1, seat 08\n"
}

resource "local_file" "seat_f_1_09" {
  filename = "${path.module}/seats/f-1-09.txt"
  content  = "Block F, row 1, seat 09\n"
}

resource "local_file" "seat_f_1_10" {
  filename = "${path.module}/seats/f-1-10.txt"
  content  = "Block F, row 1, seat 10\n"
}

resource "local_file" "seat_f_2_01" {
  filename = "${path.module}/seats/f-2-01.txt"
  content  = "Block F, row 2, seat 01\n"
}

resource "local_file" "seat_f_2_02" {
  filename = "${path.module}/seats/f-2-02.txt"
  content  = "Block F, row 2, seat 02\n"
}

resource "local_file" "seat_f_2_03" {
  filename = "${path.module}/seats/f-2-03.txt"
  content  = "Block F, row 2, seat 03\n"
}

resource "local_file" "seat_f_2_04" {
  filename = "${path.module}/seats/f-2-04.txt"
  content  = "Block F, row 2, seat 04\n"
}

resource "local_file" "seat_f_2_05" {
  filename = "${path.module}/seats/f-2-05.txt"
  content  = "Block F, row 2, seat 05\n"
}

resource "local_file" "seat_f_2_06" {
  filename = "${path.module}/seats/f-2-06.txt"
  content  = "Block F, row 2, seat 06\n"
}

resource "local_file" "seat_f_2_07" {
  filename = "${path.module}/seats/f-2-07.txt"
  content  = "Block F, row 2, seat 07\n"
}

resource "local_file" "seat_f_2_08" {
  filename = "${path.module}/seats/f-2-08.txt"
  content  = "Block F, row 2, seat 08\n"
}

resource "local_file" "seat_f_2_09" {
  filename = "${path.module}/seats/f-2-09.txt"
  content  = "Block F, row 2, seat 09\n"
}

resource "local_file" "seat_f_2_10" {
  filename = "${path.module}/seats/f-2-10.txt"
  content  = "Block F, row 2, seat 10\n"
}

resource "local_file" "seat_f_3_01" {
  filename = "${path.module}/seats/f-3-01.txt"
  content  = "Block F, row 3, seat 01\n"
}

resource "local_file" "seat_f_3_02" {
  filename = "${path.module}/seats/f-3-02.txt"
  content  = "Block F, row 3, seat 02\n"
}

resource "local_file" "seat_f_3_03" {
  filename = "${path.module}/seats/f-3-03.txt"
  content  = "Block F, row 3, seat 03\n"
}

resource "local_file" "seat_f_3_04" {
  filename = "${path.module}/seats/f-3-04.txt"
  content  = "Block F, row 3, seat 04\n"
}

resource "local_file" "seat_f_3_05" {
  filename = "${path.module}/seats/f-3-05.txt"
  content  = "Block F, row 3, seat 05\n"
}

resource "local_file" "seat_f_3_06" {
  filename = "${path.module}/seats/f-3-06.txt"
  content  = "Block F, row 3, seat 06\n"
}

resource "local_file" "seat_f_3_07" {
  filename = "${path.module}/seats/f-3-07.txt"
  content  = "Block F, row 3, seat 07\n"
}

resource "local_file" "seat_f_3_08" {
  filename = "${path.module}/seats/f-3-08.txt"
  content  = "Block F, row 3, seat 08\n"
}

resource "local_file" "seat_f_3_09" {
  filename = "${path.module}/seats/f-3-09.txt"
  content  = "Block F, row 3, seat 09\n"
}

resource "local_file" "seat_f_3_10" {
  filename = "${path.module}/seats/f-3-10.txt"
  content  = "Block F, row 3, seat 10\n"
}

resource "local_file" "seat_f_4_01" {
  filename = "${path.module}/seats/f-4-01.txt"
  content  = "Block F, row 4, seat 01\n"
}

resource "local_file" "seat_f_4_02" {
  filename = "${path.module}/seats/f-4-02.txt"
  content  = "Block F, row 4, seat 02\n"
}

resource "local_file" "seat_f_4_03" {
  filename = "${path.module}/seats/f-4-03.txt"
  content  = "Block F, row 4, seat 03\n"
}

resource "local_file" "seat_f_4_04" {
  filename = "${path.module}/seats/f-4-04.txt"
  content  = "Block F, row 4, seat 04\n"
}

resource "local_file" "seat_f_4_05" {
  filename = "${path.module}/seats/f-4-05.txt"
  content  = "Block F, row 4, seat 05\n"
}

resource "local_file" "seat_f_4_06" {
  filename = "${path.module}/seats/f-4-06.txt"
  content  = "Block F, row 4, seat 06\n"
}

resource "local_file" "seat_f_4_07" {
  filename = "${path.module}/seats/f-4-07.txt"
  content  = "Block F, row 4, seat 07\n"
}

resource "local_file" "seat_f_4_08" {
  filename = "${path.module}/seats/f-4-08.txt"
  content  = "Block F, row 4, seat 08\n"
}

resource "local_file" "seat_f_4_09" {
  filename = "${path.module}/seats/f-4-09.txt"
  content  = "Block F, row 4, seat 09\n"
}

resource "local_file" "seat_f_4_10" {
  filename = "${path.module}/seats/f-4-10.txt"
  content  = "Block F, row 4, seat 10\n"
}

resource "local_file" "seat_f_5_01" {
  filename = "${path.module}/seats/f-5-01.txt"
  content  = "Block F, row 5, seat 01\n"
}

resource "local_file" "seat_f_5_02" {
  filename = "${path.module}/seats/f-5-02.txt"
  content  = "Block F, row 5, seat 02\n"
}

resource "local_file" "seat_f_5_03" {
  filename = "${path.module}/seats/f-5-03.txt"
  content  = "Block F, row 5, seat 03\n"
}

resource "local_file" "seat_f_5_04" {
  filename = "${path.module}/seats/f-5-04.txt"
  content  = "Block F, row 5, seat 04\n"
}

resource "local_file" "seat_f_5_05" {
  filename = "${path.module}/seats/f-5-05.txt"
  content  = "Block F, row 5, seat 05\n"
}

resource "local_file" "seat_f_5_06" {
  filename = "${path.module}/seats/f-5-06.txt"
  content  = "Block F, row 5, seat 06\n"
}

resource "local_file" "seat_f_5_07" {
  filename = "${path.module}/seats/f-5-07.txt"
  content  = "Block F, row 5, seat 07\n"
}

resource "local_file" "seat_f_5_08" {
  filename = "${path.module}/seats/f-5-08.txt"
  content  = "Block F, row 5, seat 08\n"
}

resource "local_file" "seat_f_5_09" {
  filename = "${path.module}/seats/f-5-09.txt"
  content  = "Block F, row 5, seat 09\n"
}

resource "local_file" "seat_f_5_10" {
  filename = "${path.module}/seats/f-5-10.txt"
  content  = "Block F, row 5, seat 10\n"
}
