INCH = 25.4;

// Translates inches to gauge size
IMPERIAL_GAUGE_SIZE_TABLE = [
            [ "#0", 0.060 * INCH],
            [ "#1", 0.073 * INCH],
            [ "#2", 0.086 * INCH],
            [ "#3", 0.099 * INCH],
            [ "#4", 0.112 * INCH],
            [ "#5", 0.125 * INCH],
            [ "#6", 0.138 * INCH],
            [ "#7", 0.151 * INCH],
            [ "#8", 0.164 * INCH],
            [ "#9", 0.177 * INCH],
            ["#10", 0.190 * INCH],
            ["#11", 0.203 * INCH],
            ["#12", 0.216 * INCH],
            ["#14", 0.242 * INCH],
            [  "¼", 1/4   * INCH],
            ["⁵⁄₁₆", 5/16  * INCH],
            [  "⅜", 3/8   * INCH],
            ["⁷⁄₁₆", 7/16  * INCH],
            [  "½", 1/2   * INCH],
            ["⁹⁄₁₆", 9/16  * INCH],
            [  "⅝", 5/8   * INCH],
            [  "¾", 3/4   * INCH],
            [  "⅞", 7/8   * INCH],
            [  "1", 1     * INCH],
            ["1-⅛", 9/8   * INCH],
            ["1-¼", 5/4   * INCH]  
           ];

function diameter_to_gauge(diameter) =
    let(
        index = search(diameter, IMPERIAL_GAUGE_SIZE_TABLE, index_col_num=1)
    )
    assert(len(index) == 1, str(diameter, " (", diameter * INCH, "\") is not found in the lookup table."))
    IMPERIAL_GAUGE_SIZE_TABLE[index[0]][0];
      

function gauge_to_diameter(gauge) =
    let(
        index = search([gauge], IMPERIAL_GAUGE_SIZE_TABLE)
    )
    is_string(gauge)?
        IMPERIAL_GAUGE_SIZE_TABLE[index[0]][1] :
        gauge * INCH;

text(str(gauge_to_diameter("#8")), font="DejaVu Sans:style=Book");