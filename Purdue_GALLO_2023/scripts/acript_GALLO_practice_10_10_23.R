##########
####Libraries
library(genomation)
library(GALLO)
library(visNetwork)
library(igraph)
############

#Setting work directory
setwd("~/post_doc_Leon/Classes/Purdue_17_10_23/practice_GALLO/")


###########
###########
####Variants
###########
###########

#Running plink to filter vcf file

##Filtering ped and map
system("plink --file input/merged_Cons_plink --allow-extra-chr --keep input/samples_keep_Cons.txt --maf 0.05 --geno 0 --recode --out merged_vcf_Cons_filter")

#Checking outputs
dir()

#Uploading variants which passed the filter
vars.ok<-read.table("merged_vcf_Cons_filter.map",h=F)

#dim(vars.ok)

#Preparing input for gene annotation
inp.anno<-data.frame(chr=vars.ok$V1, start=vars.ok$V4, end=vars.ok$V4)


#######
#######
###Annotation of variants within genes and gene parts
########

#Importing database for feature annotation
feat.obj.rambv2=readTranscriptFeatures("database/GCF_016772045.1_ARS-UI_Ramb_v2.0_genomic.sorted.bed",remove.unusual = F)

#Annotate given object with promoter, exon, intron and intergenic regions
anno.res<-annotateWithGeneParts(as(inp.anno,"GRanges"),feat.obj.rambv2)

#Extracting data based on tSS
genes.table<-getAssociationWithTSS(anno.res)

#Merging with variant table
genes.table<-cbind(inp.anno,genes.table)


#Importing gtf file with gene symbol information and coordinates
gene.obj.rambv2=rtracklayer::import("database/GCF_016772045.1_ARS-UI_Ramb_v2.0_genomic.gtf")
gene.obj.rambv2<-as.data.frame(gene.obj.rambv2)
gene.obj.rambv2<-gene.obj.rambv2[which(gene.obj.rambv2$type=="transcript"),]

#Matching feature ID and gene symbol
genes.table$Gene_symbol<-gene.obj.rambv2[match(genes.table$feature.name,gene.obj.rambv2$transcript_id),"gene_id"]

#head(genes.table)

#Annotating gene parts
matrix.members<-as.data.frame(getMembers(anno.res))

#head(matrix.members)

#Combining with gene information
genes.table<-cbind(genes.table,matrix.members)

head(genes.table)

#Filtering those variants mapped on promoter region
genes.table.prom<-genes.table[which(genes.table$prom==1),]


###########
###########
####DMRs
###########
###########

#Loading DMR file 
dmr.file<-read.table("input/dmr_consensus_milk_Coef_cgcontent_results.txt",h=T)


#Uploading a file to match chr IDs
match.chr<-read.table("input/match_chromosome_Nc_sheep_Ramb_v2.txt",h=T,sep="\t")

#Matching
dmr.file$NC<-match.chr[match(dmr.file$chr,match.chr$chr),"NC"]

#Renaming columns
colnames(dmr.file)[c(1,7)]<-c("chr_num","chr")

#Annotating features for DMR
anno.res.dmrs<-annotateWithGeneParts(as(dmr.file,"GRanges"),feat.obj.rambv2)
genes.table.dmr<-getAssociationWithTSS(anno.res.dmrs)

#Merging results
genes.table.dmr<-cbind(dmr.file,genes.table.dmr)


#Getting Gene symbol and genomic coordinates
genes.table.dmr$Gene_symbol<-gene.obj.rambv2[match(genes.table.dmr$feature.name,gene.obj.rambv2$transcript_id),"gene_id"]

genes.table.dmr$CHR<-gsub("chr","",genes.table.dmr$chr_num)

genes.table.dmr$BP1<-gene.obj.rambv2[match(genes.table.dmr$feature.name,gene.obj.rambv2$transcript_id),"start"]

genes.table.dmr$BP2<-gene.obj.rambv2[match(genes.table.dmr$feature.name,gene.obj.rambv2$transcript_id),"end"]


###############
###############
##Annotating QTLs
###############
###############

#Filtering dmr file to keep only those DMRs within genes harboring variants in 
#promoter region
cand.dmr<-genes.table.dmr[which(genes.table.dmr$Gene_symbol%in%
                                                 genes.table.prom$Gene_symbol),]

cand.dmr<-cand.dmr[-grep("LOC",cand.dmr$Gene_symbol),]

#Number of DMRs and genes
dim(cand.dmr)

length(unique(cand.dmr$Gene_symbol))


#Importing QTL db
qtl.db<-import_gff_gtf("database/QTLdb_sheepOAR_rambo2.gff",file_type = "gff")

#Manipulation of flipped coordinates
tmp.pos<-which(qtl.db$start_pos>qtl.db$end_pos)
tmp.start<-qtl.db$start_pos[tmp.pos]
qtl.db[tmp.pos,"start_pos"]<-qtl.db[tmp.pos,"end_pos"]
qtl.db[tmp.pos,"end_pos"]<-tmp.start

#Annotating QTLs using GALLO
out.qtls<-find_genes_qtls_around_markers(qtl.db, marker_file = cand.dmr, 
                                             method="qtl", marker= "haplotype", 
                                             interval= 0)

#QTL enrichment
enrich.qtl<-qtl_enrich(qtl_db=qtl.db,
                           qtl_file=out.qtls,
                           qtl_type="Name",
                           enrich_type="genome",
                           padj = "fdr")

#Filtering enriched QTLs
enrich.qtl<-enrich.qtl[which(enrich.qtl$adj.pval<0.05),]

#Selecting enriched QTLs from annotation results
out.qtls.enrich<-out.qtls[which(out.qtls$Name%in%enrich.qtl$QTL),]


##############
##############
###Network analysis
##############
##############

# Create an empty graph object
g <- igraph::graph.empty()

# Add edges to the graph using the dataframe columns
g <- igraph::graph.data.frame(out.qtls.enrich[,c("Gene_symbol","Name")], directed = FALSE)

#Convert this graph to visNetwork format
visGraph <- toVisNetworkData(g)

#Modifying edges
edges<-visGraph$edges
edges$color<-"gray"

#Modifying nodes
nodes<-visGraph$nodes
nodes$size<-30

#Change color by Genes 
nodes[which(nodes$id%in%unique(out.qtls.enrich$Gene_symbol)),"color"]<-"purple"

##Meat and carcass
meat<-unique(out.qtls.enrich[which(out.qtls.enrich$QTL_type=="Meat_and_Carcass"),"Name"])
nodes[which(nodes$id%in%meat),"color"]<-"aquamarine"

##Production
prod<-unique(out.qtls.enrich[which(out.qtls.enrich$QTL_type=="Production"),"Name"])
nodes[which(nodes$id%in%prod),"color"]<-"blue"

##Exterior
ext<-unique(out.qtls.enrich[which(out.qtls.enrich$QTL_type=="Exterior"),"Name"])
nodes[which(nodes$id%in%ext),"color"]<-"darkgreen"

##Health
health<-unique(out.qtls.enrich[which(out.qtls.enrich$QTL_type=="Health"),"Name"])
nodes[which(nodes$id%in%health),"color"]<-"gold"

##Milk
milk<-unique(out.qtls.enrich[which(out.qtls.enrich$QTL_type=="Milk"),"Name"])
nodes[which(nodes$id%in%milk),"color"]<-"red"

##Reproduction
repro<-unique(out.qtls.enrich[which(out.qtls.enrich$QTL_type=="Reproduction"),"Name"])
nodes[which(nodes$id%in%repro),"color"]<-"orange"

##Wool
wool<-unique(out.qtls.enrich[which(out.qtls.enrich$QTL_type=="Wool"),"Name"])
nodes[which(nodes$id%in%wool),"color"]<-"lightgreen"


#Changing label size
nodes[which(nodes$id%in%unique(out.qtls.enrich$Name)),"size"]<-15
nodes[which(nodes$id%in%unique(out.qtls.enrich$Gene_symbol)),"size"]<-40

#Plotting network
visNetwork(nodes = nodes, edges = edges) %>%
  visOptions(highlightNearest = T, nodesIdSelection = TRUE, clickToUse =T) %>%
  visNodes(font = list(size = 45)) %>%  visIgraphLayout() %>%
  visPhysics(solver = "forceAtlas2Based",
             forceAtlas2Based = list(gravitationalConstant = -100))


#Getting hub genes
bet.shared.QTL<-as.data.frame(betweenness(g))

quantile(bet.shared.QTL$`betweenness(g)`, 0.75)

bet.shared.QTL<-bet.shared.QTL[which(bet.shared.QTL$`betweenness(g)`>quantile(bet.shared.QTL$`betweenness(g)`, 0.75)),,drop=F]


bet.shared.QTL<-bet.shared.QTL[which(rownames(bet.shared.QTL)%in%out.qtls.enrich$Gene_symbol),,drop=F]


bet.shared.QTL[order(bet.shared.QTL$`betweenness(g)`, decreasing = T),,drop=F]

#########
#########
#Hub genes
#########
#########

# Create an empty graph object
g <- igraph::graph.empty()

# Add edges to the graph using the dataframe columns
g <- igraph::graph.data.frame(out.qtls.enrich[which(out.qtls.enrich$Gene_symbol%in%rownames(bet.shared.QTL)),c("Gene_symbol","Name")], directed = FALSE)

#Convert this graph to visNetwork format
visGraph <- toVisNetworkData(g)

#Modifying edges
edges<-visGraph$edges
edges$color<-"gray"

#Modifying nodes
nodes<-visGraph$nodes
nodes$size<-30

#Change color by Genes 
nodes[which(nodes$id%in%unique(out.qtls.enrich$Gene_symbol)),"color"]<-"purple"

##Meat and carcass
meat<-unique(out.qtls.enrich[which(out.qtls.enrich$QTL_type=="Meat_and_Carcass"),"Name"])
nodes[which(nodes$id%in%meat),"color"]<-"aquamarine"

##Production
prod<-unique(out.qtls.enrich[which(out.qtls.enrich$QTL_type=="Production"),"Name"])
nodes[which(nodes$id%in%prod),"color"]<-"blue"

##Exterior
ext<-unique(out.qtls.enrich[which(out.qtls.enrich$QTL_type=="Exterior"),"Name"])
nodes[which(nodes$id%in%ext),"color"]<-"darkgreen"

##Health
health<-unique(out.qtls.enrich[which(out.qtls.enrich$QTL_type=="Health"),"Name"])
nodes[which(nodes$id%in%health),"color"]<-"gold"

##Milk
milk<-unique(out.qtls.enrich[which(out.qtls.enrich$QTL_type=="Milk"),"Name"])
nodes[which(nodes$id%in%milk),"color"]<-"red"

##Reproduction
repro<-unique(out.qtls.enrich[which(out.qtls.enrich$QTL_type=="Reproduction"),"Name"])
nodes[which(nodes$id%in%repro),"color"]<-"orange"

##Wool
wool<-unique(out.qtls.enrich[which(out.qtls.enrich$QTL_type=="Wool"),"Name"])
nodes[which(nodes$id%in%wool),"color"]<-"lightgreen"


#Changing label size
nodes[which(nodes$id%in%unique(out.qtls.enrich$Name)),"size"]<-15
nodes[which(nodes$id%in%unique(out.qtls.enrich$Gene_symbol)),"size"]<-40

#Plotting network
visNetwork(nodes = nodes, edges = edges) %>%
  visOptions(highlightNearest = T, nodesIdSelection = TRUE, clickToUse =T) %>%
  visNodes(font = list(size = 45)) %>%  visIgraphLayout() %>%
  visPhysics(solver = "forceAtlas2Based",
             forceAtlas2Based = list(gravitationalConstant = -100))
