# Gamlss summary function that does not print out anything but returns all the information
# instead. In particular, this is the only way to extract the "coef.table" information.
#
# (Luc Demortier, 25 March 2017)
#---------------------------------------------------------------------------------------
summarynoprint.gamlss<- function (object,
                           type = c("vcov", "qr"), robust = FALSE,
                           save = FALSE,
                           hessian.fun = c("R", "PB"),
                           digits = max(3, getOption("digits") - 3),
                           ...)
{
  type <- match.arg(type)
  if (type=="vcov")
  {
    covmat <- try(suppressWarnings(vcov(object, type="all", robust=robust,  hessian.fun = hessian.fun)), silent = TRUE)
    if (any(class(covmat)%in%"try-error"||any(is.na(covmat$se))))
    {
      type <- "qr"
    }
  }
  ifWarning <- rep(FALSE, length(object$parameters))# to create warnings
  if (type=="vcov")
  {
    coef <- covmat$coef
    se <- covmat$se
    tvalue <- coef/se
    pvalue <-  2 * pt(-abs(tvalue), object$df.res)
    coef.table <- cbind(coef, se, tvalue, pvalue)
    dimnames(coef.table) <- list(names(coef), c("Estimate" , "Std. Error" ,"t value","Pr(>|t|)"))
    est.disp <- FALSE
    #================ mu ESTIMATES ========================
    if ("mu"%in%object$parameters)
    {
      if (length(eval(parse(text=paste(paste("object$","mu", sep=""),".fix==TRUE", sep=""))))!=0)
      {
        pm <- 1
        p1 <- 1:pm
      } else
      {
        if (object$mu.df != 0)
        {
          pm <- object$mu.qr$rank
          p1 <- 1:pm
        }
      }
    }
    if ("sigma"%in%object$parameters)
    {
      if (length(eval(parse(text=paste(paste("object$","sigma", sep=""),".fix==TRUE", sep=""))))!=0)
      {
        ps <- 1
        p1 <- (pm+1):(pm+ps)
      } else
      {
        if (object$sigma.df != 0)
        {
          ps <- object$sigma.qr$rank
          p1 <- (pm+1):(pm+ps)
        }
      }
    }
    if ("nu"%in%object$parameters)
    {
      if (length(eval(parse(text=paste(paste("object$","nu", sep=""),".fix==TRUE", sep=""))))!=0)
      {
        pn <- 1
        p1 <- (pm+ps+1):(pm+ps+pn)
      } else
      {
        if (object$nu.df != 0)
        {
          pn <- object$nu.qr$rank
          p1 <- (pm+ps+1):(pm+ps+pn)
        }
      }
    }
    if ("tau"%in%object$parameters)
    {
      if (length(eval(parse(text=paste(paste("object$","tau", sep=""),".fix==TRUE", sep=""))))!=0)
      {
        pt <- 1
        p1 <- (pm+ps+pn+1):(pm+ps+pn+pt)
      } else
      {
        if (object$tau.df != 0)
        {
          pt <- object$tau.qr$rank
          p1 <- (pm+ps+pn+1):(pm+ps+pn+pt)
        }
      }
    }
  }
if (type=="qr")#     TYPE qr ---------------------------------------------------
  {
# local function definition
#-------------------------------------------------------------------------------
        estimatesgamlss<-function (object,Qr, p1, coef.p, est.disp , df.r, digits = max(3, getOption("digits") - 3), covmat.unscaled , ...)
          {
                             #covmat.unscaled <- chol2inv(Qr$qr[p1, p1, drop = FALSE])
             dimnames(covmat.unscaled) <- list(names(coef.p), names(coef.p))
                                covmat <- covmat.unscaled #in glm is=dispersion * covmat.unscaled, but here is already multiplied by the dispersion
                                var.cf <- diag(covmat)
                                 s.err <- sqrt(var.cf)
                                tvalue <- coef.p/s.err
                                    dn <- c("Estimate", "Std. Error")
                          if (!est.disp)
                             {
                                            pvalue <- 2 * pnorm(-abs(tvalue))
                                        coef.table <- cbind(coef.p, s.err, tvalue, pvalue)
                              dimnames(coef.table) <- list(names(coef.p), c(dn, "z value",
                                                    "Pr(>|z|)"))
                             }
                           else if (df.r > 0)
                             {
                                           pvalue <- 2 * pt(-abs(tvalue), df.r)
                                       coef.table <- cbind(coef.p, s.err, tvalue, pvalue)
                             dimnames(coef.table) <- list(names(coef.p), c(dn, "t value","Pr(>|t|)"))
                             }
                           else
                           {
                                          coef.table <- cbind(coef.p, Inf)
                                dimnames(coef.table) <- list(names(coef.p), dn)
                           }
                          return(coef.table)
          }
##------------------------------------------------------------------------------
# here for the proper function
##------------------------------------------------------------------------------
      dispersion <- NULL
    est.disp <- FALSE
        df.r <- object$noObs - object$mu.df
#================ mu ESTIMATES ========================
    if ("mu"%in%object$parameters)
    {
        if (object$mu.df != 0)
        {
            Qr <- object$mu.qr
            df.r <- object$noObs - object$mu.df
            ## this should be taken out sinse there is no dispersion MS Thursday, August 17, 2006
            if (is.null(dispersion))
                dispersion <- if (any(object$family == c("PO",
                                    "BI", "EX", "P1")))
                                    1
                            else if (df.r > 0) {
                                                est.disp <- TRUE
                                                if (any(object$weights == 0))
                                                        warning(paste("observations with zero weight",
                                                        "not used for calculating dispersion"))
                                                }
            else Inf
            #---------------------------------------------------end of taken out
                        p <- object$mu.df #  object$rank
                        p1 <- 1:(p-object$mu.nl.df)
            covmat.unscaled <- chol2inv(Qr$qr[p1, p1, drop = FALSE])
            mu.coef.table <- estimatesgamlss(object=object,Qr=object$mu.qr, p1=p1,
                                        coef.p=object$mu.coefficients[Qr$pivot[p1]],
                                        est.disp =est.disp, df.r=df.r,
                                        covmat.unscaled =covmat.unscaled )
        }
        else
        coef.table <- mu.coef.table
    }
    else
    {
        if (df.r > 0) {
                        est.disp <- TRUE
                        if (any(object$weights == 0))
                        warning(paste("observations with zero weight",
                        "not used for calculating dispersion"))
                        }
    }
    if ("sigma"%in%object$parameters)
    {
         if (object$sigma.df != 0)
        {
                      Qr <- object$sigma.qr
                    df.r <- object$noObs - object$sigma.df
                       p <- object$sigma.df
                      p1 <- 1:(p-object$sigma.nl.df)
        covmat.unscaled <- chol2inv(Qr$qr[p1, p1, drop = FALSE])
        sigma.coef.table<-estimatesgamlss(object=object,Qr=object$sigma.qr, p1=p1,
                                       coef.p=object$sigma.coefficients[Qr$pivot[p1]],
                                       est.disp =est.disp, df.r=df.r,
                                       covmat.unscaled =covmat.unscaled )
        }
        else
         coef.table <- rbind(mu.coef.table, sigma.coef.table)
    }
    if ("nu"%in%object$parameters)
    {
         if (object$nu.df != 0)
        {
                     Qr <- object$nu.qr
                   df.r <- object$noObs - object$nu.df
                      p <- object$nu.df
                     p1 <- 1:(p-object$nu.nl.df)
        covmat.unscaled <- chol2inv(Qr$qr[p1, p1, drop = FALSE])
          nu.coef.table <- estimatesgamlss(object=object,Qr=object$nu.qr, p1=p1,
                                       coef.p=object$nu.coefficients[Qr$pivot[p1]],
                                       est.disp =est.disp, df.r=df.r,
                                       covmat.unscaled =covmat.unscaled )
        }
        else
         coef.table <- rbind(mu.coef.table, sigma.coef.table, nu.coef.table)
    }

    if ("tau"%in%object$parameters)
   {
         if (object$tau.df != 0)
        {
                     Qr <- object$tau.qr
                   df.r <- object$noObs - object$tau.df
                      p <- object$tau.df
                     p1 <- 1:(p-object$tau.nl.df)
        covmat.unscaled <- chol2inv(Qr$qr[p1, p1, drop = FALSE])
         tau.coef.table <- estimatesgamlss(object=object,Qr=object$tau.qr, p1=p1,
                                       coef.p=object$tau.coefficients[Qr$pivot[p1]],
                                       est.disp =est.disp, df.r=df.r,
                                       covmat.unscaled =covmat.unscaled )
        }
        else
         coef.table <- rbind(mu.coef.table, sigma.coef.table, nu.coef.table, tau.coef.table)
   }
  }
out <- as.list(environment())
return(out)
invisible(coef.table)
}
