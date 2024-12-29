# Design Document

E-commerce website By Nazar MELNYK

Video overview: <URL HERE>

## Scope

> In this section you should answer the following questions:
> 
> * What is the purpose of your database?
> * Which people, places, things, etc. are you including in the scope of your database?
> * Which people, places, things, etc. are *outside* the scope of your database?

The system we are going to build a database for is an e-commerce website, where customers can make their orders.

The purpose of the database is to describe all the essential entities and actions which could possibly happen while using the system.


The system is composed of the following main entities:
- Customer
- Product
- Order
- Address


Out of scope are:

- **Payment systems**. We suppose customer always has sufficient resources and every payment is successful, and the seller is automically reimbursed for thier products
- **Shipment systems**. We suppose every shipment is successful, without delays and package damages
- **Sellers variaty**. We suppose there exists only one generic seller
- **Stock availability**. We suppose products are available in unlimited quantities


## Functional Requirements

> In this section you should answer the following questions:
> 
> * What should a user be able to do with your database?
> * What's beyond the scope of what a user should be able to do with your database?

Customer can :
- with regards to a **product** :
    - add a product item to a shopping cart,
    - adjust its quantity within a shopping cart,
    - remove an item from the shopping cart
- with regards to a **shipping address** :
    - add new shipping address
    - edit shipping address
    - remove shipping address
- with regards to a **shipping method** :
    - select a shipment method among the methods available
- with regards to a **payment method** :
    - select a payment method among the methods available
- with regards to an **order**:
    - make payment

Seller can:
- place products to the marketplace
-


checks:
- either products are available in quantities expected
-

Out of scope:
-


## Representation

> In this section you should answer the following questions:
> 
> * Which entities will you choose to represent in your database?
> * What attributes will those entities have?
> * Why did you choose the types you did?
> * Why did you choose the constraints you did?

### Entities

Inside the `marketplace.db` you will find the entitilies listed and described more in details just below

#### Sellers

Sellers are the

#### Products

#### Customers

Customers visit the marketplace, select order

#### Orders
#### Shippings
#### Addresses
#### Payment methods
#### Shipment methods



See the section on [`Limitations`](#Limitations)\.

### Relationships

> In this section you should include your entity relationship diagram and describe the relationships between the entities in your database.

## Optimizations

> In this section you should answer the following questions:
> 
> * Which optimizations (e.g., indexes, views) did you create? Why?

## Limitations

> In this section you should answer the following questions:
> 
> * What are the limitations of your design?
> * What might your database not be able to represent very well?
