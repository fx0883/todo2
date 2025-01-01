import os
from celery import Celery
from django.conf import settings

# 设置默认的 Django settings module
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'todoServer.settings')

app = Celery('todoServer')

# 使用 Django 的配置文件配置 Celery
app.config_from_object('django.conf:settings', namespace='CELERY')

# 设置 broker URL，如果 Redis 不可用则使用内存作为 broker
try:
    import redis
    redis_client = redis.Redis(host='localhost', port=6379, db=0)
    redis_client.ping()
    broker_url = 'redis://localhost:6379/0'
except (redis.ConnectionError, ImportError):
    broker_url = 'memory:///'

app.conf.update(
    broker_url=broker_url,
    task_always_eager=broker_url == 'memory:///',  # 如果使用内存，则同步执行任务
    task_eager_propagates=True,
    worker_prefetch_multiplier=1,
    task_ignore_result=True,
)

# 自动发现任务
app.autodiscover_tasks()

@app.task(bind=True)
def debug_task(self):
    print(f'Request: {self.request!r}')
