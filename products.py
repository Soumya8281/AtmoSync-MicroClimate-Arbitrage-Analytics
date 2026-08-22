import scrapy
from datetime import datetime
from amazon_scraper.items import AmazonProductItem


class ProductsSpider(scrapy.Spider):
    name = "products"

    # Books to Scrape is a public training site with stable product markup.
    allowed_domains = ["books.toscrape.com"]
    start_urls = ["https://books.toscrape.com/catalogue/page-1.html"]

    def parse(self, response):
        for product in response.css("article.product_pod"):
            item = AmazonProductItem()

            item["product_name"] = product.css("h3 a::attr(title)").get()
            item["price"] = product.css(".price_color::text").get()
            item["rating"] = product.css(".star-rating::attr(class)").get()
            item["review_count"] = None
            item["availability"] = product.css(".availability::text").get()

            href = product.css("h3 a::attr(href)").get()
            item["product_url"] = response.urljoin(href) if href else None

            image_url = product.css("img::attr(src)").get()
            item["image_url"] = response.urljoin(image_url) if image_url else None
            item["scraped_at"] = datetime.now().isoformat()

            yield item

        next_page = response.css("li.next a::attr(href)").get()
        if next_page:
            yield response.follow(next_page, callback=self.parse)
