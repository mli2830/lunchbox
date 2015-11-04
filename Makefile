##Make stuff
target pngtarget pdftarget vtarget acrtarget: RSIwrapJAGS.Rout 

##################################################################

msrepo = https://github.com/dushoff

gitroot = ../
-include local.mk
-include $(gitroot)/local.mk
ms = $(gitroot)/makestuff



SImod: SIsimulator.R SImodel.bug RSIwrapJAGS.R
				R CMD BATCH RSIwrapJAGS.R
