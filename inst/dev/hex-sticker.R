library(magick)
library(hexSticker)
library(showtext)

font_add_google("Shadows Into Light", family = "shadow")
bg <- rgb(250/255, 236/255, 199/255)
border <- rgb(25/255, 25/255, 19/255)

logo <- image_read("inst/images/survivor-logo.png")
s <- sticker(
  logo,
  package="survivoR",
  p_size=24, p_y = 0.55, p_color = border, p_family = "shadow",
  s_x=1, s_y=1.2, s_width=1.5, s_height=1.5,
  h_fill = bg, h_size = 2, h_color = border,
  filename="images/hex.png")
s
