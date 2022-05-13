open Ava

module Common = {
  let any = %raw(`"Hello world!"`)
  let factory = () => S.unknown()

  test("Successfully constructs", t => {
    let struct = factory()

    t->Assert.deepEqual(any->S.constructWith(struct), Ok(any), ())
  })

  test("Successfully destructs", t => {
    let struct = factory()

    t->Assert.deepEqual(any->S.decodeWith(struct), Ok(any), ())
  })

  test("Successfully decodes", t => {
    let struct = factory()

    t->Assert.deepEqual(any->S.decodeWith(struct), Ok(any), ())
  })

  test("Successfully encodes", t => {
    let struct = factory()

    t->Assert.deepEqual(any->S.encodeWith(struct), Ok(any), ())
  })
}

module Custom = {
  external unsafeStringToUnknown: string => S.unknown = "%identity"

  test(
    "Constructs data and destructs it back to the initial state with coercion. aka custom struct factory",
    t => {
      let any = %raw(`"Hello world!"`)

      let struct = S.unknown()->S.coerce(
        ~constructor=unknown => {
          switch unknown->Js.Types.classify {
          | JSString(string) => Ok(string)
          | _ => Error("Custom isn't a String")
          }
        },
        ~destructor=value => value->unsafeStringToUnknown->Ok,
        (),
      )

      t->Assert.deepEqual(
        any->S.constructWith(struct)->Belt.Result.map(record => record->S.destructWith(struct)),
        Ok(Ok(any)),
        (),
      )
    },
  )
}
