# Production-Grade E-Commerce Database Architecture & Business Analytics

A comprehensive relational database solution built from scratch using **PostgreSQL**. This project highlights Enterprise Schema Design, Data Administration (DBA) practices, Core Security, Index Optimization, and Advanced Business Intelligence queries.

## Database Relational Schema Layout
The system implements a normalized relational model ensuring strong referential integrity across transactional entities:
*   **customers**: Centralized profile data with explicit uniqueness constraints.
*   **products**: System inventory catalog enforcing monetary storage scaling (`NUMERIC`).
*   **orders**: Main transaction log managing data cascade rules (`ON DELETE CASCADE`).
*   **order_items**: High-volume transaction line bridge map managing strict structural restrictions (`ON DELETE RESTRICT`).

---

## Key Database Administration & Architecture Capabilities Proved:
*   **Advanced Multi-Table Joins:** Linking multi-layered junction tables smoothly to generate complete transactional views.
*   **Data Aggregation & Financial Analysis:** Executing deep calculations like Customer Lifetime Value (LTV) and individual category net profit metrics.
*   **Common Table Expressions (CTEs):** Writing organized, multi-step relational pipelines instead of unmaintainable nested subqueries.
*   **Window Functions (Analytics Engine):** Calculating continuous running revenue totals and category rank positions without losing foundational transactional rows.
*   **Performance Optimization (Indexing):** Architecting optimized B-Tree indexes on core transaction paths, minimizing table execution times.
*   **Data Integrity & Enterprise Security Constraints:** Creating custom table parameters (`ALTER CHECK`) and assigning restricted database roles (`GRANT SELECT`) to prevent internal system leaks.

---

## Technical Stack Applied
*   **Engine Backend:** PostgreSQL
*   **Interface Manager:** pgAdmin 4
*   **Language Scripting:** Data Definition Language (DDL), Data Manipulation Language (DML)

---

## Repository Contents
*   `database_setup_and_queries.sql`: Complete production script containing structural tables, mock transaction records and complex optimization routines.

---
**Developed by Henry Panashe Sithole**  
*Computer Science Professional | Database Specialist*
