open Ava

module Common = {
  let value = None
  let any = %raw(`null`)
  let wrongAny = %raw(`123.45`)
  let factory = () => S.null(S.string())

  ava->test("Successfully parses", t => {
    let struct = factory()

    t->Assert.deepEqual(any->S.parseWith(struct), Ok(value), ())
  })

  ava->test("Fails to parse", t => {
    let struct = factory()

    t->Assert.deepEqual(
      wrongAny->S.parseWith(struct),
      Error({
        code: UnexpectedType({expected: "String", received: "Float"}),
        operation: Parsing,
        path: [],
      }),
      (),
    )
  })

  ava->test("Successfully serializes", t => {
    let struct = factory()

    t->Assert.deepEqual(value->S.serializeWith(struct), Ok(any), ())
  })
}

ava->test("Successfully parses primitive", t => {
  let struct = S.null(S.bool())

  t->Assert.deepEqual(Js.Json.boolean(true)->S.parseWith(struct), Ok(Some(true)), ())
})

ava->test("Fails to parse JS undefined", t => {
  let struct = S.null(S.bool())

  t->Assert.deepEqual(
    %raw(`undefined`)->S.parseWith(struct),
    Error({
      code: UnexpectedType({expected: "Bool", received: "Option"}),
      operation: Parsing,
      path: [],
    }),
    (),
  )
})

ava->test("Fails to parse record with missing field that marked as null", t => {
  let struct = S.record1(. ("nullableField", S.null(S.string())))

  t->Assert.deepEqual(
    %raw(`{}`)->S.parseWith(struct),
    Error({
      code: UnexpectedType({expected: "String", received: "Option"}),
      operation: Parsing,
      path: ["nullableField"],
    }),
    (),
  )
})

ava->test("Fails to parse JS null when struct doesn't allow optional data", t => {
  let struct = S.bool()

  t->Assert.deepEqual(
    %raw(`null`)->S.parseWith(struct),
    Error({
      code: UnexpectedType({expected: "Bool", received: "Null"}),
      operation: Parsing,
      path: [],
    }),
    (),
  )
})

ava->test("Successfully parses null and serializes it back for deprecated nullable struct", t => {
  let struct = S.null(S.bool())->S.deprecated()

  t->Assert.deepEqual(
    %raw(`null`)->S.parseWith(struct)->Belt.Result.map(S.serializeWith(_, struct)),
    Ok(Ok(%raw(`null`))),
    (),
  )
})

ava->test("Successfully parses null and serializes it back for optional nullable struct", t => {
  let struct = S.option(S.null(S.bool()))

  t->Assert.deepEqual(
    %raw(`null`)->S.parseWith(struct)->Belt.Result.map(S.serializeWith(_, struct)),
    Ok(Ok(%raw(`null`))),
    (),
  )
})
