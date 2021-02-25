open Test
open Belt.Result

let intEqual = (~message=?, a: int, b: int) =>
  assertion(~message?, ~operator="intEqual", (a, b) => a === b, a, b)

let stringEqual = (~message=?, a: string, b: string) =>
  assertion(~message?, ~operator="stringEqual", (a, b) => a == b, a, b)

let stringResultEqual = (
  ~message=?,
  a: Belt.Result.t<string, string>,
  b: Belt.Result.t<string, string>,
) => assertion(~message?, ~operator="stringEqual", (a, b) => a == b, a, b)

test("heightEncoder", () => {
  stringResultEqual(Ok("178"), Demo.heightEncoder("178cm"))
  stringResultEqual(Ok("134.62"), Demo.heightEncoder("53in"))
  stringResultEqual(Error("invalid height"), Demo.heightEncoder("hello"))
})

test("hclEncoder", () => {
  stringResultEqual(Ok("#123456"), Demo.hclEncoder("#123456"))
  stringResultEqual(Error("invalid hexa color code"), Demo.hclEncoder("533333"))
  stringResultEqual(Error("invalid hexa color code"), Demo.hclEncoder("#123"))
})

test("cidEncoder", () => {
  stringResultEqual(Ok("12345"), Demo.cidEncoder("12345"))
  stringResultEqual(Error("Empty CID"), Demo.cidEncoder("    "))
})

test("parsePassportLine", () => {
  stringResultEqual(
    Ok(
      "{\"ecl\":gry,\"pid\":860033327,\"eyr\":2020,\"hcl\":#fffffd,\"byr\":1937,\"iyr\":2017,\"cid\":147,\"hgt\":183}",
    ),
    Demo.encodePassportLine("ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm"),
  )
  stringResultEqual(
    Ok(
      "{\"iyr\":2013,\"ecl\":amb,\"cid\":350,\"eyr\":2023,\"pid\":028048884,\"hcl\":#cfa07d,\"byr\":1929}",
    ),
    Demo.encodePassportLine("iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929"),
  )
})
