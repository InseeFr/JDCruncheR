testthat::test_that("QR works", {
    path1 <- testthat::test_path("data", "demetra_m1.csv")
    extract_QR(file = path1) |>
        expect_message()

    path2 <- testthat::test_path("data", "demetra_m2.csv")
    extract_QR(file = path2) |>
        expect_message() |>
        expect_warning(regexp = "arima\\.p")

    path3 <- testthat::test_path("data", "demetra_m3.csv")
    qr3 <- extract_QR(file = path3)
})
