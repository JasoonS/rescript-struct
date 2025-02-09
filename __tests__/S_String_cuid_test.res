open Ava

test("Successfully parses valid data", t => {
  let struct = S.string->S.String.cuid()

  t->Assert.deepEqual(
    "ckopqwooh000001la8mbi2im9"->S.parseAnyWith(struct),
    Ok("ckopqwooh000001la8mbi2im9"),
    (),
  )
})

test("Fails to parse invalid data", t => {
  let struct = S.string->S.String.cuid()

  t->Assert.deepEqual(
    "cifjhdsfhsd-invalid-cuid"->S.parseAnyWith(struct),
    Error({
      code: OperationFailed("Invalid CUID"),
      operation: Parsing,
      path: S.Path.empty,
    }),
    (),
  )
})

test("Successfully serializes valid value", t => {
  let struct = S.string->S.String.cuid()

  t->Assert.deepEqual(
    "ckopqwooh000001la8mbi2im9"->S.serializeToUnknownWith(struct),
    Ok(%raw(`"ckopqwooh000001la8mbi2im9"`)),
    (),
  )
})

test("Fails to serialize invalid value", t => {
  let struct = S.string->S.String.cuid()

  t->Assert.deepEqual(
    "cifjhdsfhsd-invalid-cuid"->S.serializeToUnknownWith(struct),
    Error({
      code: OperationFailed("Invalid CUID"),
      operation: Serializing,
      path: S.Path.empty,
    }),
    (),
  )
})

test("Returns custom error message", t => {
  let struct = S.string->S.String.cuid(~message="Custom", ())

  t->Assert.deepEqual(
    "cifjhdsfhsd-invalid-cuid"->S.parseAnyWith(struct),
    Error({
      code: OperationFailed("Custom"),
      operation: Parsing,
      path: S.Path.empty,
    }),
    (),
  )
})

test("Returns refinement", t => {
  let struct = S.string->S.String.cuid()

  t->Assert.deepEqual(struct->S.String.refinements, [{kind: Cuid, message: "Invalid CUID"}], ())
})
