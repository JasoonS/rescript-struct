open Ava

test("Successfully parses valid data", t => {
  let struct = S.array(S.int)->S.Array.max(1)

  t->Assert.deepEqual([1]->S.parseAnyWith(struct), Ok([1]), ())
  t->Assert.deepEqual([]->S.parseAnyWith(struct), Ok([]), ())
})

test("Fails to parse invalid data", t => {
  let struct = S.array(S.int)->S.Array.max(1)

  t->Assert.deepEqual(
    [1, 2, 3, 4]->S.parseAnyWith(struct),
    Error({
      code: OperationFailed("Array must be 1 or fewer items long"),
      operation: Parsing,
      path: S.Path.empty,
    }),
    (),
  )
})

test("Successfully serializes valid value", t => {
  let struct = S.array(S.int)->S.Array.max(1)

  t->Assert.deepEqual([1]->S.serializeToUnknownWith(struct), Ok(%raw(`[1]`)), ())
  t->Assert.deepEqual([]->S.serializeToUnknownWith(struct), Ok(%raw(`[]`)), ())
})

test("Fails to serialize invalid value", t => {
  let struct = S.array(S.int)->S.Array.max(1)

  t->Assert.deepEqual(
    [1, 2, 3, 4]->S.serializeToUnknownWith(struct),
    Error({
      code: OperationFailed("Array must be 1 or fewer items long"),
      operation: Serializing,
      path: S.Path.empty,
    }),
    (),
  )
})

test("Returns custom error message", t => {
  let struct = S.array(S.int)->S.Array.max(~message="Custom", 1)

  t->Assert.deepEqual(
    [1, 2]->S.parseAnyWith(struct),
    Error({
      code: OperationFailed("Custom"),
      operation: Parsing,
      path: S.Path.empty,
    }),
    (),
  )
})

test("Returns refinement", t => {
  let struct = S.array(S.int)->S.Array.max(1)

  t->Assert.deepEqual(
    struct->S.Array.refinements,
    [{kind: Max({length: 1}), message: "Array must be 1 or fewer items long"}],
    (),
  )
})
