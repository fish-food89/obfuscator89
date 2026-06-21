extends GutTest
## Tests the  Utils.find_array_first_element()` function.


var sunny_day_parameters: Array = self.ParameterFactory.named_parameters(
    # names
    [
        "source",
        "what",
        "from",
        "expected_result",
    ],
    # values
    [
        [
            [1, 2, 3],  # source
            [1],  # what
            0,  # from
            0,  # expected_result
        ],
        [
            [1, 2, 3],
            [2],
            0,
            1,
        ],
        [
            [1, 2, 3],
            [3],
            0,
            2,
        ],
        [
            [1, 2, 3],
            [1],
            1,
            -1,
        ],
        [
            [1, 2, 3],
            [4],
            0,
            -1,
        ],
        [
            [1, 2, 3],
            [1],
            5,
            -1,
        ],
        [
            ["F", "o", "o", "B", "a", "r", "B", "a", "z"],
            ["B", "a", "r"],
            0,
            3,
        ],
        [
            ["F", "o", "o", "B", "a", "r", "B", "a", "z"],
            ["a", "r"],
            1,
            4,
        ],
        [
            ["F", "o", "o", "B", "a", "r", "B", "a", "z"],
            ["h", "i"],
            0,
            -1,
        ],
        [
            ["F", "o", "o", "B", "a", "r", "B", "a", "z"],
            ["B", "a", "r"],
            9,
            -1,
        ],
    ],
)


func test_sunny_day(p = self.use_parameters(sunny_day_parameters)) -> void:
    self.assert_eq(
        ArrayTools.find_array_first_element(
            p.source,
            p.what,
            p.from,
        ),
        p.expected_result,
        "Wrong index returned!",
    )
