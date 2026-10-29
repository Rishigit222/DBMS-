# Experiment 4: Conceptual ER Diagram

## Aim

Model an e-commerce platform using entities, relationships, keys, weak order-line entities, and a self-referencing product category hierarchy.

## Design

The diagram covers customers, orders, order items, products, sellers, and categories. `ORDER_ITEM` resolves the many-to-many relationship between orders and products, while `CATEGORY` supports nested categories through `Parent_ID`.

- [Mermaid ER diagram](./er_diagram.mermaid)
- [Original submission](./dbms_exp_4.pdf)
