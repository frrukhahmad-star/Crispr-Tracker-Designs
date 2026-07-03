create database if not exists crispr_design_tracker;
use crispr_design_tracker;

create table genes(

gene_id int primary key auto_increment,
gene_symbol varchar(20),
ncbi_gene_id int not null ,
chromosome varchar(30),
full_name varchar(50)
);

set foreign_key_checks = 0;

drop table if exists genes ;

create table target_reigons(

reigon_id int auto_increment primary key,
gene_id int not null,
exon_number int not null,
genomic_coordinates varchar(50) not null ,
foreign key (gene_id)
references genes(gene_id) 
on delete cascade
);
drop table if exists target_reigons;

create table gRNA_designs(

grna_id int auto_increment primary key,
reigon_id int not null,
grna_sequence varchar(50) not null,
pam_sequnce varchar(5) not null default 'NGG',
strand varchar(1) not null,
gc_content decimal(4,2) not null,
efficiency_score decimal(5,2) not null,
foreign key (reigon_id)
references target_reigons(reigon_id)
on delete cascade 
);
drop table if  exists gRNA_designs;

create table off_target_matches(

off_target_id int auto_increment primary key,
grna_id int ,
mismatch_count int not null,
genomic_location varchar(50) not null ,
is_in_exon bool not null,
foreign key (grna_id)
references gRNA_designs(grna_id)
on delete cascade
);
drop table if exists off_target_matches;

create table experimental_validation(
experiment_id int auto_increment primary key,
grna_id int,
cell_line varchar(50) not null,
knockout_efficiency decimal(5,2) not null,
validation_method varchar(50) not null,
experiment_date date not null,
foreign key (grna_id)
references gRNA_designs(grna_id)
on delete cascade
);
drop table if exists experimental_validtaion;




INSERT INTO genes (gene_symbol, ncbi_gene_id, chromosome, full_name) VALUES
('EGFR', 1956, '7', 'Epidermal Growth Factor Receptor'),
('BRCA1', 672, '17', 'BRCA1 DNA Repair Associated'),
('VEGFA', 7422, '6', 'Vascular Endothelial Growth Factor A');


INSERT INTO target_reigons (gene_id, exon_number, genomic_coordinates) VALUES
(1, 18, 'chr7:55152345-55152500'),
(1, 19, 'chr7:55153900-55154050'),
(2, 11, 'chr17:43091435-43091600'),
(3, 3, 'chr6:43772100-43772250');


INSERT INTO gRNA_designs (reigon_id, grna_sequence, pam_sequnce , strand, gc_content, efficiency_score) VALUES
(1, 'GCAATATCAGCCTTAGGTGC', 'CGG', '+', 50.00, 82.40),
(1, 'ATGAGCTGCGTGATGAGCTG', 'AGG', '-', 55.00, 41.20),
(2, 'GAGGTGAAATTTCAGGACGC', 'TGG', '+', 45.00, 89.10),
(3, 'TAATCGCCGTAGCGATGCTG', 'GGG', '+', 55.00, 76.50),
(4, 'CCGTACTGTCGTACTGTCGA', 'TGG', '-', 50.00, 33.80);


INSERT INTO off_target_matches (grna_id, mismatch_count, genomic_location, is_in_exon) VALUES
(1, 3, 'chr3:120454310', FALSE),
(2, 1, 'chr7:55201140', TRUE),
(3, 4, 'chrX:7419920', FALSE),
(4, 2, 'chr6:43900150', FALSE),
(5, 0, 'chr12:11204500', TRUE);


INSERT INTO experimental_validation (grna_id, cell_line, knockout_efficiency, validation_method, experiment_date) VALUES
(1, 'HEK293', 84.50, 'NGS', '2026-02-14'),
(2, 'HeLa', 22.10, 'T7E1 Assay', '2026-03-01'),
(3, 'HEK293', 91.00, 'Western Blot', '2026-03-18'),
(4, 'A549', 73.20, 'NGS', '2026-04-05');


select g.grna_id, g.grna_sequence, g.efficiency_score, g.gc_content
from gRNA_designs as g
where g.efficiency_score > 80
and g.grna_id not in (
select distinct otm.gRNA_id
from off_target_matches as otm
where otm.mismatch_count < 3
);


