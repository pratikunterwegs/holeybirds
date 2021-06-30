
#' Simple net squared displacement. Assumes coordinates in metres.
#'
#' @param data The data frame.
#' @param x The column name of the X coordinate.
#' @param y The column name of the Y coordinate.
#'
#' @return A vector of net squared displacement.
#' @export
#'
get_nsd = function(data, x = "x", y = "y", time = "time") {

    # set order by timestamps
    data.table::setorderv(data, time)

    # get starting coordinates
    x_1 = data[[x]][1]
    y_1 = data[[y]][1]

    # get net displacement
    net_displacement = sqrt(
        ((data[[x]] - x_1) ^ 2) + ((data[[y]] - y_1) ^ 2)
    )

    # square the net displacement
    net_displacement ^ 2
}
