open Ava

ava->test("Successfully parses valid data", t => {
  let struct = S.float()->S.Float.max(1.)

  t->Assert.deepEqual(1->S.parseWith(struct), Ok(1.), ())
  t->Assert.deepEqual(-1->S.parseWith(struct), Ok(-1.), ())
})

ava->test("Fails to parse invalid data", t => {
  let struct = S.float()->S.Float.max(1.)

  t->Assert.deepEqual(
    1234->S.parseWith(struct),
    Error({
      code: OperationFailed("Number must be lower than or equal to 1"),
      operation: Parsing,
      path: [],
    }),
    (),
  )
})

ava->test("Successfully serializes valid value", t => {
  let struct = S.float()->S.Float.max(1.)

  t->Assert.deepEqual(1.->S.serializeWith(struct), Ok(%raw(`1`)), ())
  t->Assert.deepEqual(-1.->S.serializeWith(struct), Ok(%raw(`-1`)), ())
})

ava->test("Fails to serialize invalid value", t => {
  let struct = S.float()->S.Float.max(1.)

  t->Assert.deepEqual(
    1234.->S.serializeWith(struct),
    Error({
      code: OperationFailed("Number must be lower than or equal to 1"),
      operation: Serializing,
      path: [],
    }),
    (),
  )
})

ava->test("Returns custom error message", t => {
  let struct = S.float()->S.Float.max(~message="Custom", 1.)

  t->Assert.deepEqual(
    12.->S.parseWith(struct),
    Error({
      code: OperationFailed("Custom"),
      operation: Parsing,
      path: [],
    }),
    (),
  )
})
