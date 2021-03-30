library(magick)
library(hexSticker)

logo <- image_read("man/dev/images/torch.png")
s <- sticker(
  logo,
  package="",
  p_size=20, p_y = 0.55, p_color = "orange", p_family = "shadow",
  s_x=1, s_y=1, s_width=1.29, s_height=1.29,
  h_fill = "black", h_size = 1, h_color = "orange",
  filename="man/dev/images/hex-torch.png")
s

