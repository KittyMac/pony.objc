

struct CGPoint
  var x:F64
  var y:F64
  new create(x':F64 = 0, y':F64 = 0) =>
    x = x'
    y = y'

struct CGSize
  var width:F64
  var height:F64
  new create(w:F64 = 0, h:F64 = 0) =>
    width = w
    height = h

struct CGRect
  embed origin:CGPoint = CGPoint
  embed size:CGSize = CGSize

  new create(x:F64, y:F64, w:F64, h:F64) =>
    origin.x = x
    origin.y = y
    size.width = w
    size.height = h
    
