open Ava

test("Successfully parses object with quotes in a field name", t => {
  let struct = S.object(o =>
    {
      "field": o.field("\"\'\`", S.string),
    }
  )

  t->Assert.deepEqual(%raw(`{"\"\'\`": "bar"}`)->S.parseAnyWith(struct), Ok({"field": "bar"}), ())
})

test("Successfully serializing object with quotes in a field name", t => {
  let struct = S.object(o =>
    {
      "field": o.field("\"\'\`", S.string),
    }
  )

  t->Assert.deepEqual(
    {"field": "bar"}->S.serializeToUnknownWith(struct),
    Ok(%raw(`{"\"\'\`": "bar"}`)),
    (),
  )
})

test("Successfully parses object transformed to object with quotes in a field name", t => {
  let struct = S.object(o =>
    {
      "\"\'\`": o.field("field", S.string),
    }
  )

  t->Assert.deepEqual(%raw(`{"field": "bar"}`)->S.parseAnyWith(struct), Ok({"\"\'\`": "bar"}), ())
})

test("Successfully serializes object transformed to object with quotes in a field name", t => {
  let struct = S.object(o =>
    {
      "\"\'\`": o.field("field", S.string),
    }
  )

  t->Assert.deepEqual(
    {"\"\'\`": "bar"}->S.serializeToUnknownWith(struct),
    Ok(%raw(`{"field": "bar"}`)),
    (),
  )
})

test("Successfully parses object with discriminant which has quotes as the field name", t => {
  let struct = S.object(o => {
    ignore(o.field("\"\'\`", S.literal(EmptyNull)))
    {
      "field": o.field("field", S.string),
    }
  })

  t->Assert.deepEqual(
    %raw(`{
      "\"\'\`": null,
      "field": "bar",
    }`)->S.parseAnyWith(struct),
    Ok({"field": "bar"}),
    (),
  )
})

test("Successfully serializes object with discriminant which has quotes as the field name", t => {
  let struct = S.object(o => {
    ignore(o.field("\"\'\`", S.literal(EmptyNull)))
    {
      "field": o.field("field", S.string),
    }
  })

  t->Assert.deepEqual(
    {"field": "bar"}->S.serializeToUnknownWith(struct),
    Ok(
      %raw(`{
        "\"\'\`": null,
        "field": "bar",
      }`),
    ),
    (),
  )
})

test("Successfully parses object with discriminant which has quotes as the literal value", t => {
  let struct = S.object(o => {
    ignore(o.field("kind", S.literal(String("\"\'\`"))))
    {
      "field": o.field("field", S.string),
    }
  })

  t->Assert.deepEqual(
    %raw(`{
      "kind": "\"\'\`",
      "field": "bar",
    }`)->S.parseAnyWith(struct),
    Ok({"field": "bar"}),
    (),
  )
})

test(
  "Successfully serializes object with discriminant which has quotes as the literal value",
  t => {
    let struct = S.object(o => {
      ignore(o.field("kind", S.literal(String("\"\'\`"))))
      {
        "field": o.field("field", S.string),
      }
    })

    t->Assert.deepEqual(
      {"field": "bar"}->S.serializeToUnknownWith(struct),
      Ok(
        %raw(`{
          "kind": "\"\'\`",
          "field": "bar",
        }`),
      ),
      (),
    )
  },
)

test(
  "Successfully parses object transformed to object with quotes in name of hardcoded field",
  t => {
    let struct = S.object(o =>
      {
        "\"\'\`": "hardcoded",
        "field": o.field("field", S.string),
      }
    )

    t->Assert.deepEqual(
      %raw(`{"field": "bar"}`)->S.parseAnyWith(struct),
      Ok({
        "\"\'\`": "hardcoded",
        "field": "bar",
      }),
      (),
    )
  },
)

test(
  "Successfully serializes object transformed to object with quotes in name of hardcoded field",
  t => {
    let struct = S.object(o =>
      {
        "\"\'\`": "hardcoded",
        "field": o.field("field", S.string),
      }
    )

    t->Assert.deepEqual(
      {
        "\"\'\`": "hardcoded",
        "field": "bar",
      }->S.serializeToUnknownWith(struct),
      Ok(%raw(`{"field": "bar"}`)),
      (),
    )
  },
)

test(
  "Successfully parses object transformed to object with quotes in value of hardcoded field",
  t => {
    let struct = S.object(o =>
      {
        "hardcoded": "\"\'\`",
        "field": o.field("field", S.string),
      }
    )

    t->Assert.deepEqual(
      %raw(`{"field": "bar"}`)->S.parseAnyWith(struct),
      Ok({
        "hardcoded": "\"\'\`",
        "field": "bar",
      }),
      (),
    )
  },
)

test(
  "Successfully serializes object transformed to object with quotes in value of hardcoded field",
  t => {
    let struct = S.object(o =>
      {
        "hardcoded": "\"\'\`",
        "field": o.field("field", S.string),
      }
    )

    t->Assert.deepEqual(
      {
        "hardcoded": "\"\'\`",
        "field": "bar",
      }->S.serializeToUnknownWith(struct),
      Ok(%raw(`{"field": "bar"}`)),
      (),
    )
  },
)

test("Has proper error path when fails to parse object with quotes in a field name", t => {
  let struct = S.object(o =>
    {
      "field": o.field("\"\'\`", S.string->S.refine(~parser=_ => S.fail("User error"), ())),
    }
  )

  t->Assert.deepEqual(
    %raw(`{"\"\'\`": "bar"}`)->S.parseAnyWith(struct),
    Error({
      code: OperationFailed("User error"),
      operation: Parsing,
      path: S.Path.fromArray(["\"\'\`"]),
    }),
    (),
  )
})

test("Has proper error path when fails to serialize object with quotes in a field name", t => {
  let struct = S.object(o =>
    Js.Dict.fromArray([
      ("\"\'\`", o.field("field", S.string->S.refine(~serializer=_ => S.fail("User error"), ()))),
    ])
  )

  t->Assert.deepEqual(
    Js.Dict.fromArray([("\"\'\`", "bar")])->S.serializeToUnknownWith(struct),
    Error({
      code: OperationFailed("User error"),
      operation: Serializing,
      path: S.Path.fromArray(["\"\'\`"]),
    }),
    (),
  )
})

test("Field name in a format of a path is handled properly", t => {
  let struct = S.object(o =>
    {
      "field": o.field(`["abc"]["cde"]`, S.string),
    }
  )

  t->Assert.deepEqual(
    %raw(`{"bar": "foo"}`)->S.parseAnyWith(struct),
    Error({
      code: UnexpectedType({expected: "String", received: "Option"}),
      operation: Parsing,
      path: S.Path.fromArray([`["abc"]["cde"]`]),
    }),
    (),
  )
})
