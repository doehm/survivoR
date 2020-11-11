library(magick)
library(hexSticker)
library(showtext)

font_add_google("Shadows Into Light", family = "shadow")
bg <- rgb(250/255, 236/255, 199/255)
border <- rgb(25/255, 25/255, 19/255)
green <- rgb(59, 169, 69, maxColorValue = 255)
greena <- colorRampPalette(c(green, "white"))(10)

logo <- image_read("inst/images/survivor-logo.png")
s <- sticker(
  logo,
  package="survivoR",
  p_size=24, p_y = 0.55, p_color = green, p_family = "shadow",
  s_x=1, s_y=1.2, s_width=1.5, s_height=1.5,
  h_fill = bg, h_size = 2, h_color = border,
  filename="images/hex.png")
s

logo <- image_read("inst/images/survivor-logo-1.png")
s <- sticker(
  logo,
  package="",
  p_size=20, p_y = 0.55, p_color = green, p_family = "shadow",
  s_x=1, s_y=1, s_width=1.65, s_height=1.65,
  h_fill = greena[5], h_size = 1, h_color = green,
  filename="inst/images/hex-1.png")
s
