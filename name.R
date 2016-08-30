targetname <-unlist(strsplit(rtargetname,"[.]"))

type <- targetname[2]
process <- targetname[3]
observation <- targetname[4]
seed <- targetname[5]
iterations <- targetname[6]