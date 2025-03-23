# Odoo Performance Optimization

## We cannot improve what we cannot measure

## And that's where Locust and Odoo Profiler come in

### Tools

https://locust.io/

https://github.com/odoo/OdooLocust

### Sources

https://www.odoo.com/fr_FR/event/odoo-experience-2024-4662/track/our-best-tips-to-optimize-the-performance-of-your-module-6644

https://medium.com/@ERPserviceprovider/maximizing-efficiency-performance-optimization-tips-for-your-odoo-instance-d701e7fd2bc3

https://www.cybrosys.com/blog/how-to-optimize-an-odoo-server-postgresql

Here, I will only introduce you to Locust

### Why use Locust?

Locust is an open-source load testing tool that allows you to:

- **Simulate real users** interacting with a system
- **Measure** the performance of each function and request
- **Identify bottlenecks** in the code

### Setting up Locust with Odoo

cf [README.md](README.md)

### Interpreting Results

Key metrics to monitor in Locust results:

| Metric                         | Description                                      | Importance                    |
|--------------------------------|--------------------------------------------------|-------------------------------|
| Median response time (Median)  | Effective execution time                         | For general performance       |
| 95%ile response time           | Worst-case performance for 95% of users          | For measuring stability       |
| Requests/second (RPS)          | Number of requests per second                    | For measuring capacity        |
| Response size (Average size)   | Volume of data transferred                       | Efficiency                    |

**Practice:** Launch locust and interpret the results

## 2. Best Practices for a Performant Odoo System

### A. ORM Query Optimization

#### 1. Avoid the N+1 problem with `read_group`

This involves avoiding executing 1 query to retrieve N results and then making N additional queries
to retrieve the data we're looking for.

**Non-performant:**
```python
def count_books_by_collection_np(self):
    collections = self.env['bookstore.collection'].search([])
    result = {}
    
    for collection in collections:
        domain = [('collection_id', '=', collection.id)]
        book_count = self.search_count(domain)
        # ...
```

**Performant:**
```python
def count_books_by_collection(self):
    counts_data = self.read_group(
        domain=[('collection_id', '!=', False)],
        fields=['collection_id'],
        groupby=['collection_id']
    )
    # ...
```

**Interpret the results of the associated functions**

#### 2. Avoid doing `search` and then `read`, but use `search_read` or `search_fetch` or `browse`

search_fetch() was introduced from Odoo 17 and allows results to be cached

**Non-performant:**
```python
def show_all_books_name_of_test_collection_3_np(self):
    collection = self.env["bookstore.collection"].search([("name", "=", "Test Collection 3")])
    books = self.search([("collection_id", "=", collection.id)])
    return books.mapped("name")
```

**Performant:**
```python
def show_all_books_name_of_test_collection_3(self):
    collections = self.env["bookstore.collection"].search_read(
        domain=[("name", "=", "Test Collection 3")],
        fields=["id"],
        limit=1
    )
    
    if not collections:
        return []
        
    collection_id = collections[0]["id"]
    
    books = self.search_read(
        domain=[("collection_id", "=", collection_id)],
        fields=["name"]
    )
    
    return [book["name"] for book in books]
```

**Interpret the results of the associated functions**

### B. Batch Processing

#### Odoo has a batch processing function `split_every` for processing data in batches

It is important to use this function, instead of creating your own batches or making complex loops.

**Non-performant:**
```python
def update_book_prices_np(self, percentage_increase):
    book_ids = self.search([]).ids
    
    for book_id in book_ids:
        book = self.browse(book_id)
        current_price = book.list_price
        new_price = current_price * (1 + percentage_increase / 100)
        book.write({'list_price': new_price})
```

**Performant:**
```python
from odoo.tools import split_every

def update_book_prices(self, percentage_increase):
    book_ids = self.search([]).ids
    
    for books_chunk in split_every(1000, book_ids):
        books = self.browse(books_chunk)
        for book in books:
            book.list_price = book.list_price * (1 + percentage_increase / 100)
```

### C. Optimize Record Creation

The `create()` method takes batch processing into account, which means that if data needs to be created
from a list, this list can be passed directly to the `create()` function

**Non-performant:**
```python
for name in ['jean', 'alain', 'nasser']:
    model.create({'name': name})
```

**Performant:**
```python
create_values = [
    {'name': 'jean'},
    {'name': 'nasser'},
    {'name': 'alain'}
]
records = model.create(create_values)
```

### D. Efficient Data Retrieval

Instead of doing a search that will retrieve all data, it is better to do a search_read
to retrieve only the data we need.

**Non-performant:**
```python
partners = self.env['res.partner'].search([])
for partner in partners:
    # Use partner.name, partner.email, etc.
```

**Performant:**
```python
partners = self.env['res.partner'].search_read(
    domain=[],
    fields=['name', 'email']
)
for partner in partners:
    # Use partner['name'] and partner['email'] only
```

## 3. Stability is not Performance

### Fundamental Difference

- **Performance**: Execution speed under normal conditions
- **Stability**: System behavior with large volumes of data

### Example: Inventory Calculation

**A fast but unstable solution:**
```python
def compute_inventory_value(self):
    products = self.env['product.product'].search([])
    return sum(p.qty_available * p.standard_price for p in products)
```

**A stable but less fast solution**
```python
def compute_inventory_value(self):
    self.env.cr.execute("""
        SELECT SUM(p.qty_available * p.standard_price)
        FROM product_product p
        WHERE p.active = true
    """)
    return self.env.cr.fetchone()[0] or 0.0
```

It could be made faster by indexing and filtering more or by using the cache
to avoid redoing calculations (store=True)

### Key Points to Remember

1. **Performance is not always the main goal**
   - It's not good to have a fast solution that fails with large volumes of data
   - Often, it's better to have a slightly slow solution that never crashes

2. **Balance is more important**
   - We need to seek both performance and stability
   - For this, it is important to test with realistic data volumes
   - And measure to improve, for example by using the Odoo Profiler or Locust