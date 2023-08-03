import system
import math
import strformat

const WIDTH = 512
const HEIGHT = 512

const
  R = 0
  G = 1
  B = 2

type Vec[N: static[int]] = array[0..N - 1, float]
type RGB = Vec[3]

proc vec[N: static[int]](s: float): Vec[N] =
  for x in result.mitems:
    x = s

proc `+`[N: static[int]](a, b: Vec[N]): Vec[N] =
  for i in 0..<N:
    result[i] = a[i] + b[i]

proc `-`[N: static[int]](a, b: Vec[N]): Vec[N] =
  for i in 0..<N:
    result[i] = a[i] - b[i]

proc `*`[N: static[int]](a, b: Vec[N]): Vec[N] =
  for i in 0..<N:
    result[i] = a[i] * b[i]

proc min[N: static[int]](a, b: Vec[N]): Vec[N] =
  for i in 0..<N:
    result[i] = min(a[i], b[i])

proc length[N: static[int]](a: Vec[N]): float =
  for i in a:
    result += i * i
  result = sqrt(result)

proc wang(bltr: uint8, uv: Vec[2]): RGB =
  let r = 0.5
  let colors = [
    [1.0, 1.0, 0.0],
    [1.0, 0.0, 1.0]
  ]
  let sides = [
    [1.0, 0.5],
    [0.5, 0.0],
    [0.0, 0.5],
    [0.5, 1.0]
  ]
  var mask = bltr
  for p in sides:
    let t = 1.0 - min(length(p - uv) / r, 1.0)
    let color = colors[mask and 1]
    result = min(result + vec[3](t) * color, vec[3](1.0))
    mask = mask shr 1

proc save_wang_tile(bltr: uint8, file_path: string): void =
  let f = open(file_path, fmWrite)
  defer: f.close

  f.write_line("P6")
  f.write_line($WIDTH & " " & $HEIGHT & " 255")

  for y in 0..<HEIGHT:
    for x in 0..<WIDTH:
      let u = cast[float](x) / cast[float](WIDTH)
      let v = cast[float](y) / cast[float](HEIGHT)
      let pixels = wang(bltr, [u, v])
      f.write(chr(int(pixels[R] * 255)))
      f.write(chr(int(pixels[G] * 255)))
      f.write(chr(int(pixels[B] * 255)))

proc main(): void =
  for bltr in 0..15:
    let file_path = fmt"tile-{bltr:02}.ppm"
    save_wang_tile(uint8(bltr), file_path)
    echo "Generated ", file_path

when isMainModule:
  main()
