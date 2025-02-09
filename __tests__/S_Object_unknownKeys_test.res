open Ava

type objectWithOneField = {key: string}

test("Successfully parses Object with unknown keys by default", t => {
  let any = %raw(`{key: "value", unknownKey: "value2"}`)

  let struct = S.object(o => o.field("key", S.string))

  t->Assert.deepEqual(any->S.parseAnyWith(struct), Ok("value"), ())
})

test("Fails fast and shows only one excees key in the error message", t => {
  let struct = S.object(o =>
    {
      "key": o.field("key", S.string),
    }
  )->S.Object.strict

  t->Assert.deepEqual(
    %raw(`{key: "value", unknownKey: "value2", unknownKey2: "value2"}`)->S.parseAnyWith(struct),
    Error({
      code: ExcessField("unknownKey"),
      operation: Parsing,
      path: S.Path.empty,
    }),
    (),
  )
})

test("Successfully parses Object with unknown keys when Strip strategy applyed", t => {
  let value = "value"
  let any = %raw(`{key: "value", unknownKey: "value2"}`)

  let struct = S.object(o => o.field("key", S.string))->S.Object.strip

  t->Assert.deepEqual(any->S.parseAnyWith(struct), Ok(value), ())
})

test("Works correctly when the same unknown keys strategy applyed multiple times", t => {
  let value = "value"
  let any = %raw(`{key: "value", unknownKey: "value2"}`)

  let struct =
    S.object(o => o.field("key", S.string))->S.Object.strip->S.Object.strip->S.Object.strip

  t->Assert.deepEqual(any->S.parseAnyWith(struct), Ok(value), ())
})

test("Doesn't raise an error when unknown keys strategy applyed to a non Object struct", t => {
  t->Assert.notThrows(() => {
    S.string->S.Object.strip->ignore
  }, ())
  t->Assert.notThrows(() => {
    S.string->S.Object.strict->ignore
  }, ())
})

test("Can reset unknown keys strategy applying Strict strategy", t => {
  let any = %raw(`{key: "value", unknownKey: "value2"}`)

  let struct = S.object(o => o.field("key", S.string))->S.Object.strip->S.Object.strict

  t->Assert.deepEqual(
    any->S.parseAnyWith(struct),
    Error({
      code: ExcessField("unknownKey"),
      operation: Parsing,
      path: S.Path.empty,
    }),
    (),
  )
})
