extends GutTest
## Tests the `ArrayTools.find_array()` function.


var params__previous_error__ok: Array = self.ParameterFactory.named_parameters(
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
            FindArrayResult.new(Error89.Code.OK, 0),  # expected_result
        ],
        [
            [1, 2, 3],
            [2],
            0,
            FindArrayResult.new(Error89.Code.OK, 1),
        ],
        [
            [1, 2, 3],
            [3],
            0,
            FindArrayResult.new(Error89.Code.OK, 2),
        ],
        [
            [1, 2, 3],
            [1],
            1,
            FindArrayResult.new(Error89.Code.WHAT_NOT_FOUND, -1),
        ],
        [
            [1, 2, 3],
            [4],
            0,
            FindArrayResult.new(Error89.Code.WHAT_NOT_FOUND, -1),
        ],
        [
            [1, 2, 3],
            [1],
            5,
            FindArrayResult.new(Error89.Code.WHAT_NOT_FOUND, -1),
        ],
        [
            ["F", "o", "o", "B", "a", "r", "B", "a", "z"],
            ["B", "a", "r"],
            0,
            FindArrayResult.new(Error89.Code.OK, 3),
        ],
        [
            ["F", "o", "o", "B", "a", "r", "B", "a", "z"],
            ["a", "r"],
            1,
            FindArrayResult.new(Error89.Code.OK, 4),
        ],
        [
            ["F", "o", "o", "B", "a", "r", "B", "a", "z"],
            ["h", "i"],
            0,
            FindArrayResult.new(Error89.Code.WHAT_NOT_FOUND, -1),
        ],
        [
            ["F", "o", "o", "B", "a", "r", "B", "a", "z"],
            ["B", "a", "r"],
            9,
            FindArrayResult.new(Error89.Code.WHAT_NOT_FOUND, -1),
        ],
    ],
)

var params__previous_error__what_cut_short: Array = self.ParameterFactory.named_parameters(
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
            FindArrayResult.new(Error89.Code.OK, 0),  # expected_result
        ],
        [
            [1, 2, 3],
            [2],
            0,
            FindArrayResult.new(Error89.Code.WHAT_NOT_FOUND, -1),
        ],
        [
            [1, 2, 3],
            [3],
            0,
            FindArrayResult.new(Error89.Code.WHAT_NOT_FOUND, -1),
        ],
        [
            [1, 2, 3],
            [1],
            1,
            FindArrayResult.new(Error89.Code.WHAT_NOT_FOUND, -1),
        ],
        [
            [1, 2, 3],
            [4],
            0,
            FindArrayResult.new(Error89.Code.WHAT_NOT_FOUND, -1),
        ],
        [
            [1, 2, 3],
            [1],
            5,
            FindArrayResult.new(Error89.Code.WHAT_NOT_FOUND, -1),
        ],
        [
            ["F", "o", "o", "B", "a", "r", "B", "a", "z"],
            ["B", "a", "r"],
            0,
            FindArrayResult.new(Error89.Code.WHAT_NOT_FOUND, -1),
        ],
        [
            ["F", "o", "o", "B", "a", "r", "B", "a", "z"],
            ["a", "r"],
            1,
            FindArrayResult.new(Error89.Code.WHAT_NOT_FOUND, -1),
        ],
        [
            ["F", "o", "o", "B", "a", "r", "B", "a", "z"],
            ["h", "i"],
            0,
            FindArrayResult.new(Error89.Code.WHAT_NOT_FOUND),
        ],
        [
            ["F", "o", "o", "B", "a", "r", "B", "a", "z"],
            ["B", "a", "r"],
            9,
            FindArrayResult.new(Error89.Code.WHAT_NOT_FOUND),
        ],
    ],
)


## Tests the behaviour when the `previous_error` argument is given the value
## `Error89.Code.OK`.
func test_previous_error__ok(params=self.use_parameters(params__previous_error__ok)) -> void:
    var result: FindArrayResult = ArrayTools.find_array(
        params.source,
        params.what,
        params.from,
        Error89.Code.OK,
    )

    self.assert_is(result, FindArrayResult, "Wrong child class!")
    self.assert_eq(result.get_class_name(), params.expected_result.get_class_name())
    self.assert_eq(result.error, params.expected_result.error)
    self.assert_eq(result.index, params.expected_result.index)


## Tests the behaviour when the `previous_error` argument is given the value
## `Error89.Code.WHAT_CUT_SHORT`.
func test_previous_error__what_cut_short(
        params=self.use_parameters(params__previous_error__what_cut_short),
) -> void:
    var result: FindArrayResult = ArrayTools.find_array(
        params.source,
        params.what,
        params.from,
        Error89.Code.WHAT_CUT_SHORT,
    )

    self.assert_is(result, FindArrayResult, "Wrong child class!")
    self.assert_eq(result.get_class_name(), params.expected_result.get_class_name())
    self.assert_eq(result.error, params.expected_result.error)
    self.assert_eq(result.index, params.expected_result.index)
