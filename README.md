# Crispr-Tracker-Designs
A MySQL database project for managing CRISPR-Cas9 gRNA design, target regions, off-target analysis, and experimental validation data.

# CRISPR Design Tracker

A relational MySQL database for organizing and tracking CRISPR-Cas9 guide RNA (gRNA) design projects. This database stores gene information, target regions, designed gRNAs, off-target analysis results, and experimental validation data.

## Project Overview

The purpose of this project is to demonstrate database design and SQL skills by creating a normalized relational database for CRISPR gene-editing workflows.

The database allows users to:

- Store gene information
- Record target genomic regions
- Manage gRNA designs
- Track potential off-target matches
- Store experimental validation results
- Query high-efficiency gRNAs with minimal off-target effects

---

## Database Schema

The project contains five related tables:

### 1. Genes
Stores basic information about target genes.

| Column | Description |
|---------|-------------|
| gene_id | Primary key |
| gene_symbol | Gene symbol |
| ncbi_gene_id | NCBI Gene ID |
| chromosome | Chromosome number |
| full_name | Full gene name |

---

### 2. Target Regions
Stores genomic regions targeted for CRISPR editing.

| Column | Description |
|---------|-------------|
| region_id | Primary key |
| gene_id | Foreign key to Genes |
| exon_number | Target exon |
| genomic_coordinates | Chromosomal coordinates |

---

### 3. gRNA Designs
Contains designed guide RNA sequences.

| Column | Description |
|---------|-------------|
| grna_id | Primary key |
| region_id | Foreign key |
| grna_sequence | Guide RNA sequence |
| pam_sequence | PAM sequence |
| strand | DNA strand |
| gc_content | GC percentage |
| efficiency_score | Predicted efficiency |

---

### 4. Off-Target Matches
Stores predicted off-target binding sites.

| Column | Description |
|---------|-------------|
| off_target_id | Primary key |
| grna_id | Foreign key |
| mismatch_count | Number of mismatches |
| genomic_location | Off-target location |
| is_in_exon | Indicates exon overlap |

---

### 5. Experimental Validation
Stores laboratory validation results.

| Column | Description |
|---------|-------------|
| experiment_id | Primary key |
| grna_id | Foreign key |
| cell_line | Cell line used |
| knockout_efficiency | Experimental efficiency |
| validation_method | Validation technique |
| experiment_date | Date performed |

---

## Relationships

```
Genes
   │
   └── Target Regions
            │
            └── gRNA Designs
                     ├── Off-Target Matches
                     └── Experimental Validation
```

---

## Features

- Normalized relational database design
- Primary and foreign key constraints
- Cascading deletes
- Sample biological dataset
- SQL queries for data retrieval
- Demonstrates one-to-many relationships
- Designed for CRISPR-Cas9 workflow management

---

## Example Query

Retrieve highly efficient gRNAs (>80%) that do not have off-target matches with fewer than three mismatches.

```sql
SELECT g.grna_id,
       g.grna_sequence,
       g.efficiency_score,
       g.gc_content
FROM gRNA_designs AS g
WHERE g.efficiency_score > 80
AND g.grna_id NOT IN (
    SELECT DISTINCT otm.grna_id
    FROM off_target_matches AS otm
    WHERE otm.mismatch_count < 3
);
```

---

## Technologies Used

- MySQL
- SQL
- Relational Database Design

---

## Learning Objectives

This project demonstrates understanding of:

- Database normalization
- Entity relationships
- Primary and foreign keys
- SQL queries
- Data integrity constraints
- Biological data organization
- CRISPR data management

---

## Future Improvements

- Add researchers and laboratory information
- Support multiple CRISPR systems (Cas9, Cas12, Cas13)
- Store sequencing results
- Integrate scoring algorithms
- Add stored procedures and triggers
- Build a web interface for data management

---

## Author

**Farrukh Ahmad**

Bachelor of Science in Biotechnology
