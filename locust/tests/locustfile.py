from locust import task, between, events
from odoo import MainOdooLocustUser
import time

class BooksPerformanceTest(MainOdooLocustUser):
    wait_time = between(0.1, 10)
    database = "books"
    login = "admin"
    password = "admin"
    port = 8069
    protocol = "jsonrpc"
    host = "localhost"

    def on_start(self):
        super().on_start()
        # Initialize models
        self.product_tmpl = self.client.get_model('product.template')

    @task(3)
    def test_count_books_by_collection_np(self):
        start_time = time.time()

        result = self.product_tmpl.count_books_by_collection_np()

        execution_time = time.time() - start_time
        print(
            f"✅ Non-performant count_books_by_collection completed in {execution_time:.4f}s - Found {len(result) if result else 0} collections")

    @task(3)
    def test_count_books_by_collection(self):
        start_time = time.time()

        result = self.product_tmpl.count_books_by_collection()

        execution_time = time.time() - start_time
        print(
            f"✅ Performant count_books_by_collection completed in {execution_time:.4f}s - Found {len(result) if result else 0} collections")

    @task(3)
    def test_show_all_books_name_of_test_collection_3_np(self):
        start_time = time.time()

        result = self.product_tmpl.show_all_books_name_of_test_collection_3_np()

        execution_time = time.time() - start_time
        print(
            f"✅ Non-performant show_all_books_name_of_test_collection_3_np completed in {execution_time:.4f}s - Found {len(result) if result else 0} collections")

    @task(3)
    def test_show_all_books_name_of_test_collection_3(self):
        start_time = time.time()

        result = self.product_tmpl.show_all_books_name_of_test_collection_3()

        execution_time = time.time() - start_time
        print(
            f"✅ Performant show_all_books_name_of_test_collection_3 completed in {execution_time:.4f}s - Found {len(result) if result else 0} collections")

    @task(3)
    def test_show_all_books_name_of_test_collection_3_browse(self):
        start_time = time.time()

        result = self.product_tmpl.show_all_books_name_of_test_collection_3_browse()

        execution_time = time.time() - start_time
        print(
            f"✅ Performant show_all_books_name_of_test_collection_3_browse completed in {execution_time:.4f}s - Found {len(result) if result else 0} collections")