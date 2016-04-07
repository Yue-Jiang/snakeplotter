library(ggplot2)
MyGray <- rgb(t(col2rgb("black")), alpha=50, maxColorValue=255)

smoothCurve <- function(x0, x1, y0, y1, n, direction) {
  # x0: starting x
  # x1: ending x
  # y0: starting y
  # y1: ending y
  # n: number of residues
  # direction: 1 if n shape, -1 if u shape
  # draws a smooth curve between (x0, y0) and (x1, y1) with n redidues
  # returns coordinates of all residues on the smooth curve
  
  # for the middile part:
  m <- min((n %% 2 + 6), n) # number of residues in the middle part
  c <- mean(c(x0, x1))
  r <- 5 # redius used for plotting the middle part
  circ_part_x <- circ_part_y <- rep(0, m)
  for (i in 1:m) {
    circ_part_x[i] <- direction * cos(pi - i * pi / (m + 1)) * r + c
    circ_part_y[i] <- direction * sin(pi - i * pi / (m + 1)) * r
  }
  if (direction == -1) { circ_part_x <- rev(circ_part_x) }
  if (n <= m) { 
    if (direction == 1) { return(cbind(circ_part_x, circ_part_y + max(y0, y1))) }
    if (direction == -1) { return(cbind(circ_part_x, circ_part_y + min(y0, y1))) }
  }
  
  # for the side parts:
  ndiff <- round((y1 - y0) / 4) * 2 * direction
  # ndiff is even, how many more residues the left one should have than right
  na <- (n - m + ndiff) / 2
  nb <- (n - m - ndiff) / 2
  # if |ndiff| is too big: 
  if (ndiff >= n - m) {
    na <- n - m
    nb <- 0
  }
  if (ndiff < 0 && abs(ndiff) >= n - m) {
    na <- 0
    nb <- n - m
  }
  # note that n - m is even if n - m > 0

  xa <- rep(x0, na)
  xb <- rep(x1, nb)
  
  if (direction == 1) {
    top <- max(c(y0 + (na + 1) * 2, y1 + (nb + 1) * 2))
    circ_part_y <- circ_part_y + top
    ya <- seq(y0 + 2, top, length.out = na)
    yb <- seq(top, y1 + 2, length.out = nb)
  }
  if (direction == -1) {
    bottom <- min(c(y0 - (na - 1) * 2, y1 - (nb + 1) * 2))
    circ_part_y <- circ_part_y + bottom
    ya <- seq(y0 - 2, bottom, length.out = na)
    yb <- seq(bottom, y1 - 2, length.out = nb)
  }
  smtx <- c(xa, circ_part_x, xb)
  smty <- c(ya, circ_part_y, yb)

  return(cbind(smtx, smty))
} 
# plot(smoothCurve(0,20,10,-100,30,-1))

endCurve <- function(x0, y0, n, direction) {
  # x0: starting x
  # y0: starting y
  # n: number of residues
  # direction: 1 if n shape, -1 if u shape
  # draws a smooth curve starting at (x0, y0)  with n redidues
  # returns coordinates of all residues on the smooth curve
  
  r <- 5
  m <- min((n %% 2 + 6), n)
  
  xa <- rep(x0, n - m)
  ya <- rep(y0, n - m)
  for (i in seq_len(n - m)) { ya[i] <- y0 + i * direction * 2 }
  
  circ_part_x <- circ_part_y <- rep(0, m)
  for (i in seq_len(m)) {
    circ_part_x[i] <- direction * cos(pi-i*pi/(m+1)) * r  + x0 - direction*r
    circ_part_y[i] <- direction * sin(pi-i*pi/(m+1)) * r
  }
  
  if(direction==-1) {
    circ_part_y <- circ_part_y + min(c(ya, y0))
    smtx <- rev(c(circ_part_x,rev(xa)))
    smty <- rev(c(circ_part_y,rev(ya)))
  }
  if(direction==1) {
    circ_part_y <- circ_part_y + max(c(ya, y0))
    smtx <- c(circ_part_x,rev(xa))
    smty <- c(circ_part_y, rev(ya))
  }
  return(cbind(smtx, smty))
}

tmPart <- function (x0, y0, n, direction) {
  # x0: starting x
  # y0: starting y
  # n: number of residues
  # direction: 1 if top->down, -1 if down->top
  # draws the transmembrane part starting at (x0, y0)  with n redidues
  # returns coordinates of all residues on the transmembrane region
  
  tmx <- x0+rep(c(2,  0, -2,  3,  1, -1, -3),length.out=n)
  tmy <- rep(c(-2.987013e-08, -1.212121e+00, -2.424242e+00, -1.818182e+00, -3.030303e+00, -4.242424e+00, -5.454545e+00),length.out=n)
  for (i in 1:ceiling(n/7)) {tmy[(7*(i-1)+1):min(n,(7*i))] <- tmy[(7*(i-1)+1):min(n,(7*i))] - (i-1)*5.454545}
  tmy <- tmy + y0
  if (direction==-1) {tmx <- rev(tmx); tmy<-rev(tmy)}
  return(cbind(tmx,tmy))
}

tmToCenter <- function(TM, y_center) {
  diff <- mean(TM[,2]) - y_center
  TM[,2] <- TM[,2] - diff
  return(TM)
}

snakePlot <- function(ec1, tm1, ic1, tm2, ec2, tm3,
                      ic2, tm4, ec3, tm5, ic3, tm6,
                      ec4, tm7, ic4, pcirc, pfill, psize, lcol,
                      aa, aacol) {
  TM1 <- tmPart(x0=20, y0=90, n=tm1, direction=1) #TM1
  TM2 <- tmPart(x0=30, y0=90, n=tm2, direction=-1) #TM2
  TM3 <- tmPart(x0=40, y0=90, n=tm3, direction=1) #TM3
  TM4 <- tmPart(x0=50, y0=90, n=tm4, direction=-1) #TM4
  TM5 <- tmPart(x0=60, y0=90, n=tm5, direction=1) #TM5
  TM6 <- tmPart(x0=70, y0=90, n=tm6, direction=-1) #TM6
  TM7 <- tmPart(x0=80, y0=90, n=tm7, direction=1) #TM7

  y_center <- mean(c(TM1[,2], TM2[,2], TM3[,2], TM4[,2], TM5[,2], TM6[,2], TM7[,2]))

  TM1 <- tmToCenter(TM1, y_center)
  TM2 <- tmToCenter(TM2, y_center)
  TM3 <- tmToCenter(TM3, y_center)
  TM4 <- tmToCenter(TM4, y_center)
  TM5 <- tmToCenter(TM5, y_center)
  TM6 <- tmToCenter(TM6, y_center)
  TM7 <- tmToCenter(TM7, y_center)

  EC1 <- endCurve(x0=20, y0=TM1[1,2], n=ec1, direction=1) #EC1
  IC1 <- smoothCurve(x0=20, x1=30, y0=tail(TM1[, 2], 1) - 1, y1=TM2[1, 2] - 1, n=ic1, direction=-1) #IC1
  EC2 <- smoothCurve(x0=30, x1=40, y0=tail(TM2[, 2], 1), y1=TM3[1, 2], n=ec2, direction=1) #EC2
  IC2 <- smoothCurve(x0=40, x1=50, y0=tail(TM3[, 2], 1) - 1, y1=TM4[1, 2] - 1, n=ic2, direction=-1) #IC2
  EC3 <- smoothCurve(x0=50, x1=60, y0=tail(TM4[, 2], 1), y1=TM5[1, 2], n=ec3, direction=1) #EC3
  IC3 <- smoothCurve(x0=60, x1=70, y0=tail(TM5[, 2], 1) - 1, y1=TM6[1, 2] - 1, n=ic3, direction=-1) #IC3 #n.diff should be even numbers!?
  EC4 <- smoothCurve(x0=70, x1=80, y0=tail(TM6[, 2], 1), y1=TM7[1, 2], n=ec4, direction=1) #EC4
  IC4 <- endCurve(x0=80, y0=tail(TM7[, 2], 1) - 1, n=ic4, direction=-1) #IC4

  cord <- rbind(EC1, TM1, IC1, TM2, EC2, TM3, IC2, TM4, EC3, TM5, IC3, TM6, EC4, TM7, IC4)
  
  # process the text to be labeled, if aa is longer, chop it. if aa is shorter, use ''
  text <- rep('', dim(cord)[1])
  aaVec <- strsplit(aa, '')[[1]]
  for (i in seq_len(min(length(text), length(aaVec)))) {
    text[i] <- aaVec[i]
  }
  
  cordDf <- data.frame(x=cord[,1], y=cord[,2], text=text)
  print(cordDf)
  
  fig <- ggplot(cordDf, aes(x, y, label=text)) + 
    geom_path(color=lcol) +
    geom_point(color=pcirc, size=psize, alpha=0.9, shape=21, fill=pfill) +
    geom_text(hjust=0.5, vjust=0.5, color=aacol, size=psize * 0.9) +
    coord_fixed(ratio = 1) +
    theme_classic() +
    theme(axis.line=element_blank(),
          axis.text.x=element_blank(),
          axis.text.y=element_blank(),
          axis.ticks=element_blank(),
          axis.title.x=element_blank(),
          axis.title.y=element_blank())
  return(fig)
}

# snakePlot(20,200,10,20,20,20,20,20,20,20,20,20,20,20,20,MyGray,4,MyGray,'ADC','red')
