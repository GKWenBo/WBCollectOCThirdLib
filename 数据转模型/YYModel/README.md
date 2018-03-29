# WBMyFavoriteThirdLib（Objective-C）
github地址：https://github.com/ibireme/YYModel

Usage
1.自定义属性名称
+ (NSDictionary *) modelCustomPropertyMapper {
return @{@"errnoInteger" : @"errno"
};
}

2.属性转换
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
NSNumber *timestamp = dic[@"timestamp"];
if (![timestamp isKindOfClass:[NSNumber class]]) return NO;
_createdAt = [NSDate dateWithTimeIntervalSince1970:timestamp.floatValue];
return YES;
}

2.包含数组属性
+ (NSDictionary *)modelContainerPropertyGenericClass {
return @{@"shadows" : [YYShadow class],
@"borders" : YYBorder.class,
@"attachments" : @"YYAttachment" };
}
