getNeighbors <- function(index,xdim,ydim,consec){
  neigbors <- vector(length=0)
  
  maxIndex <- xdim * ydim
  
  for (i in 1:consec){
    neigbors <- c(neigbors, (index + xdim * i ) %% maxIndex)
    neigbors <- c(neigbors, (index - xdim * i ) %% maxIndex)
    
    neigbors <- c(neigbors, (index +  i ) %% maxIndex)
    neigbors <- c(neigbors, (index -  i ) %% maxIndex)
  }
  # if the index is 0 , set that to max Index aka last index
  neigbors[neigbors==0] <- maxIndex
  return(neigbors)
  
}

# mode : up =  1, down =  2, left = 3 ,right = 4 
checkAround <- function (index,xdim,ydim,pixAddress,consec, mode){
  
  numOfContiguous <- 0
  
  for (i in 1:consec){
    
    if (mode == 1){
      target <- c(neigbors, (index -  i ) %% maxIndex)
    }else if (mode == 2){
      target <- c(neigbors, (index +  i ) %% maxIndex)
    }else if (mode == 3){
      target <- c(neigbors, (index - xdim * i ) %% maxIndex)
    }else if (mode == 4){
      target <- c(neigbors, (index + xdim * i ) %% maxIndex)
    }
    
    
    if (target == 0){
      target <- xdim * ydim
    }
    
    if (target %in% pixAddress){
      numOfContiguous <- numOfContiguous + 1
    }
    
  }
  
  return (numOfContiguous)
  
}







handleOutBound  <- function(index,xdim,ydim){
  if (index > (xdim*ydim)){
    index <- index - (xdim*ydim)
  }
  return (index)
}






x = matrix(, nrow = 10, ncol = 10)


#y = getNeighbors(13,9,10,3)

#print(y)

#for ( i in 1:length(y) ){
#print(wrapAround(y[i],maxIndex))



# x[y[i]] <- 0
#}



message <- "abcasdaskajsdlkjlasd"

startpix <- 1


message_split <- strsplit(message, "")[[1]]

xdim <- 10

ydim <- 10



index <- startpix

consec <- 3

stride <- 3

pixAddress <- vector(length=0)






#loop over the message

for (i in message_split){
  
  
  # check surrounding with # of space in col and row
  #neigbors <- getNeighbors(index,xdim,ydim,consec)
  
  
  sumTopDown <- vector(length = 0)
  sumTopDown <- vector(length = 0)
  
  
  #check up and down 
  for ( j in 1:2){
    checkAround(index,xdim,ydim,pixAddress,consec,j)
  }
  
  #check left and right
  for ( k in 3:4){
    checkAround(index,xdim,ydim,pixAddress,consec,k)
  }
  
  
  counter <- 0
  
  while (length(intersect(neigbors,pixAddress)) > 0  || length(intersect(index,pixAddress)) > 0 ){
    
    index <- index + stride
    
    #wrap around 
    index <- handleOutBound(index,xdim,ydim)
    
    
    neigbors <- getNeighbors(index,xdim,ydim,consec)
    
    counter <- counter + 1
    
    if (counter >= xdim*ydim){
      stop("cannot find place")
    }
    
    
  }
  
  #wrap around 
  index <- handleOutBound(index,xdim,ydim)
  
  
  x[index] <- utf8ToInt(i) / 128
  pixAddress <- c(pixAddress,index)
  index <- index + stride + 1
  
  
  
  
}
#print(pixAddress)


View(x)
print(x)