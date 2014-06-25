#' Update a list by modifying its elements.
#'
#' @param x The list to be transformed
#' @param ... The elements to transform
#' @param item The symbol to represent the list item, \code{.} in default
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
  item=".",keep.names=TRUE,keep.null=FALSE,keep.val.null=FALSE) {
  args <- match.call(expand.dots = FALSE)$`...`
  enclos <- new.env(FALSE,parent.frame(),1)
  items <- lapply(x,function(i) {
    assign(item,i,envir = enclos)
    if(is.list(i) || is.environment(i)) {
      env <- i
    } else if(is.vector(i)) {
      env <- as.list(i)
    } else {
      env <- enclos
    }
    new.list <- lapply(args,function(arg) {
      eval(arg,env,enclos)
    })
    modifyList(i,new.list,keep.null = keep.val.null)
  })
  if(!keep.names) names(items) <- NULL
  if(!keep.null) items[vapply(items,is.null,logical(1))] <- NULL
  items
}