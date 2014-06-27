#' Update a list by modifying its elements.
#'
#' @param x The list to be transformed
#' @param ... The elements to update
#' @param keep.names Whether to keep the names of list x
#' @param keep.null Whether to keep \code{NULL} items in the result
#' @param keep.val.null Whether to keep \code{NULL} values in the transformed list item
#' @name list.update
#' @export
#' @examples
#' \dontrun{
#' x <- list(p1 = list(type="A",score=list(c1=10,c2=8)),
#'        p2 = list(type="B",score=list(c1=9,c2=9)),
#'        p3 = list(type="B",score=list(c1=9,c2=7)))
#' list.update(x,high=max(score$c1,score$c2),low=min(score$c1,score$c2))
#' list.update(x,exams=length(score))
#' list.update(x,grade=ifelse(type=="A",score$c1,score$c2))
#' list.update(x,score=list(min=0,max=10))
#' }
list.update <- function(x,...,
  keep.names=TRUE,keep.null=FALSE,keep.val.null=FALSE) {
  args <- match.call(expand.dots = FALSE)$`...`
  for(i in seq_along(args)) {
    arg <- args[[i]]
    arg <- substitute(arg)
    args[[i]] <- lambda(arg)
  }
  enclos <- new.env(FALSE,parent.frame(),1)
  items <- lapply(x,function(xi) {
    env <- list.env(xi,enclos)
    new.list <- lapply(args,function(arg) {
      assign(arg$symbol,xi,envir = enclos)
      eval(arg$expr,env,enclos)
    })
    modifyList(xi,new.list,keep.null = keep.val.null)
  })
  if(!keep.names) names(items) <- NULL
  if(!keep.null) items[vapply(items,is.null,logical(1))] <- NULL
  items
}