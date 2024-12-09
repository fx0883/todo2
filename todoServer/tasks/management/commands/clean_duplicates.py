from django.core.management.base import BaseCommand
from django.db.models import Count
from tasks.models import Category

class Command(BaseCommand):
    help = '清理重复的分类数据'

    def handle(self, *args, **options):
        # 找出重复的分类
        duplicates = (
            Category.objects.values('user_id', 'name')
            .annotate(count=Count('id'))
            .filter(count__gt=1)
        )

        for duplicate in duplicates:
            # 获取重复的分类记录
            categories = Category.objects.filter(
                user_id=duplicate['user_id'],
                name=duplicate['name']
            ).order_by('id')
            
            # 保留第一个记录，删除其他记录
            first_category = categories.first()
            categories.exclude(id=first_category.id).delete()
            
            self.stdout.write(
                self.style.SUCCESS(
                    f'Successfully cleaned duplicate category: {duplicate["name"]} '
                    f'for user {duplicate["user_id"]}'
                )
            )
