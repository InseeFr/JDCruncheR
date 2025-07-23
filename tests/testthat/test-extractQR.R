testthat::test_that("QR works", {

    msg1 <- "Multiple column found for extraction of f_residual_sa_on_sa
Last column selected"
    msg2 <- "Multiple column found for extraction of f_residual_sa_on_i
Last column selected"

    path1 <- testthat::test_path("data", "demetra_m1.csv")
    expect_message(
        object = expect_message(object = {
                qr1 <- extract_QR(file = path1)
            }, regexp = msg1
        ),
        regexp = msg2
    )

    path2 <- testthat::test_path("data", "demetra_m2.csv")
    expect_message(
        object = expect_message(
            object = expect_warning(
                object = {
                    qr2 <- extract_QR(file = path2)
                },
                regexp = "arima\\.p"
            ),
            regexp = msg1
        ),
        regexp = msg2
    )

    path3 <- testthat::test_path("data", "demetra_m3.csv")
    expect_message(
        object = expect_message(object = {
            qr3 <- extract_QR(file = path3)
        }, regexp = msg1
        ),
        regexp = msg2
    )

})
