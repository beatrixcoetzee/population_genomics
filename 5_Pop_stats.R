library(adegenet) # for dapc
library(vcfR) # for reading in genetic data
library(tidyverse) # for manipulating and plotting data
library(LEA) # For sNMF
library(dartR)
library(poppr)
library(haplotypes)


#############read in data from vcf######################## 
#Change input file name if necessary. 
myvcf <-read.vcfR("Plink_final.vcf")

#read in population metadata
#metadata is comma-delimited, with fields for Isolate name, origin etc.
pops <-read_csv("pops_meta.txt")
SApop2 <-as.character(pops$Locality)
SApopfac <-factor(SApop2)

#create genlight object
mygenlight <- vcfR2genlight(myvcf)
#############DAPC########################

#Find number of clusters with lowest BIC value, choose highest possible number of PCs 
num_clust <-find.clusters(mygenlight, max.n.clust=30, choose.n.clust = TRUE)

#Find number of discriminating components with lowest RSME
xvalDapc(mygenlight, grp=num_clust$grp, n.pca.max = 435, n.da = NULL,
         training.set = 0.9, result = c("groupMean", "overall"),
         center = TRUE, scale = FALSE,
         n.pca=NULL, n.rep = 30, xval.plot = TRUE)

#choose colours
myCol2 <-  c("#FF0000","#FF8000","#055c1c","#80FF00","#00FF00","#00FF80","#00FFFF","#0080FF","#0000FF","#8000FF","#FF00FF","#FF0080")

#DAPC based on locality as discriminatory function
dapc1 <- dapc(mygenlight, pop=SApopfac)
scatter(dapc1, leg=FALSE,cstar=1, cex=2,cex.lab=100, posi.da="bottomright",clabel = 1, col=myCol2,xpd=TRUE, label.inds=pops$Isolate)
dapc1_data_df <- data.frame(x = dapc1$ind.coord[,1], y = dapc1$ind.coord[,2])

#DAPC based on number of clusters as discriminatory function, choose number of discriminatory components based on lowest RSME
dapc2 <- dapc(mygenlight, num_clust$grp)

#Plot option 1
scatter(dapc2, leg=FALSE,cstar=1, cex=2,cex.lab=100, posi.da="bottomright",clabel = 1, col=myCol2,xpd=TRUE)

#Plot option 2
dapc2_data_df <-
  # as_tibble() converts the ind.coord matrix to a special data frame called a tibble. 
  as_tibble(dapc1$ind.coord, rownames = "individual") %>%
  # mutate changes or adds columns to a data frame. Here, we're adding the population and group assignment columns to the data frame
  mutate(Locality = pops$Locality,
         group = dapc2$grp)

dapc2_plot <-
  ggplot(dapc2_data_df, aes(
    x = LD1,
    y = LD2,
    fill = Locality
  )) +
  geom_point(shape = 21, size = 3) +
  theme_bw(base_size = 16)

dapc2_plot

#############Admixture################################
#create a geno object
vcf2geno("Plink_final.vcf", output.file = "mynew.geno", force = TRUE)
pops <-read_csv("pops2.txt")

#determine number of ancestral clusters based on lowest cross entropy
obj.snmf = snmf("mynew.geno", 
                K = 1:20, 
                project = "new", 
                repetitions = 10, 
                tolerance = 0.00001, 
                entropy=TRUE, 
                ploidy = 1)

#find number of clusters based on lowest cross entropy
summary(obj.snmf)
plot(obj.snmf, cex = 1.2, col = "lightblue", pch = 19)

#change K to number of clusters with lowest cross entropy
ce <- cross.entropy(obj.snmf, K = 10)
which.min(ce)
best <- which.min(ce)

#create q-matrix, change K
qmatrix = Q(obj.snmf, K = 2, run = best)
write.table(qmatrix, "qmatrix.txt")

#choose colors
myCol2 <-  c( "#FF8000","#80FF00","#FF0000","#055c1c","#00FFFF","yellow","#0000FF","#8000FF","#FF00FF","#FF0080")

#re-order q-matrix according to rank; give rank (should be availalbe in metadata) to isolates in order you want it plotted
q_df <- qmatrix %>% 
  as_tibble() %>% 
  # add the pops data for plotting
  mutate(individual = pops$Isolate,
         region = pops$Locality,
         order = pops$Rank)
q_df_sorted=q_df[order(q_df$order), ]

#change number of colomns to number of clusters you have
q_df_new<-q_df_sorted[, 1:2]

par(mar=c(6,4,4,6), xpd=TRUE)  
barplot(t(q_df_new),
        col=myCol2,
        border = NA, space = .2,
        ylab = "Admixture coefficients", 
        main = "Ancestry matrix", 
        horiz = FALSE, 
        names.arg = as.character(q_df_sorted$individual),
        cex.names=0.2, 
        las = 2,cex.lab=1)
title(xlab="Isolates", mgp=c(5,0,0),cex.lab=1)
legend("topright", inset=c(-0.12,0),
               legend = c("Cluster 1", "Cluster 2" ),
               fill = myCol2))
             
#############AMOVA###################################
#create genind object with populations assigned based on localities
SAgenind = vcfR2genind(myvcf, pop=SApopfac, ploidy=1, return.alleles = TRUE)

amova_R_locality <-poppr.amova(
  SAgenind,
  hier= ~SApop.Localities,
  within = FALSE,
  dist = NULL,
  squared = TRUE,
  freq = TRUE,
  correction = "quasieuclid",
  sep = "_",
  filter = FALSE,
  threshold = 0,
  algorithm = "farthest_neighbor",
  threads = 1L,
  missing = "loci",
  cutoff = 0.05,
  quiet = FALSE,
  method = c("ade4"),
  nperm = 99)

amova_R_locality

#############Population statistics###################################
popstat <- poppr(SAgenind)
popstat

#############Pairwise Phi values###################################
SAmatrix <-SAgenind$tab
write.table(SAmatrix, "SAmatrix")

pairPhiST_Locality <- pairPhiST(SAmatrix,SApopfac,nperm=99,negatives=FALSE, subset=NULL,showprogbar=TRUE)
pairPhiST_Locality

