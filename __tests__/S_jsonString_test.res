open Ava

test("Successfully parses JSON", t => {
  let struct = S.string

  t->Assert.deepEqual(`"Foo"`->S.parseAnyWith(S.jsonString(struct)), Ok("Foo"), ())
})

test("Fails to parse invalid JSON", t => {
  let struct = S.unknown

  t->Assert.deepEqual(
    `undefined`->S.parseAnyWith(S.jsonString(struct)),
    Error({
      code: OperationFailed("Unexpected token u in JSON at position 0"),
      operation: Parsing,
      path: S.Path.empty,
    }),
    (),
  )
})

test("Successfully serializes JSON", t => {
  let struct = S.string

  t->Assert.deepEqual(
    `Foo`->S.serializeToUnknownWith(S.jsonString(struct)),
    Ok(%raw(`'"Foo"'`)),
    (),
  )
})

Failing.test("Fails to serialize Option to JSON", t => {
  let struct = S.option(S.unknown)

  t->Assert.deepEqual(
    None->S.serializeToUnknownWith(S.jsonString(struct))->Belt.Result.isError,
    true,
    (),
  )
})
