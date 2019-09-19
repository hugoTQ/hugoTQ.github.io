

## strspn

```C
//检索字符串 str1 中第一个不在字符串 str2 中出现的字符下标
size_t strspn(const char *str1, const char *str2)

int main ()
{
   int len;
   const char str1[] = "ABCDEFG019874";
   const char str2[] = "ABCD";

   len = strspn(str1, str2);

   printf("初始段匹配长度 %d\n", len ); // 4
   
   return(0);
}   
```



## strrchr

```c
//返回s以charset开头的公共子串长度
size_t strspn(const char *s, const char *charset);
//返回s字符c第一次出现指针，若返回'\0'，表示s没有c
char* strrchr(const char *s, int c);
int main()
{
		char s[128] = "123;45";
		char *p = strchr(s, ';');
		size_t i = strspn(s, "122");
		printf("ret:chr=%s , spn=%ld\n", p, i);
		return 0;
}

ouput：
ret:chr=;45 , spn=2
```



## strtol

```C
// 把 str 看做是 base 进制数，转换为10进制 long int型 返回，遇到不合法字符则截断给endptr
long int strtol(const char *str, char **endptr, int base)
    
int main()
{
   char str[30] = "2030300 This is test";
   char *ptr;
   long ret;

   ret = strtol(str, &ptr, 10);
   printf("数字（无符号长整数）是 %ld\n", ret);
   printf("字符串部分是 |%s|", ptr);

    
   char str[30] = "2030300 This is test";
   char *ptr;
   long ret 
   ret = strtol(str, &ptr, 3);
   printf("数字（无符号长整数）是 %ld\n", ret);
   printf("字符串部分是 |%s|", ptr); 

   return(0);
}
// 数字（无符号长整数）是 2030300
//字符串部分是 | This is test|
//数字（无符号长整数）是 |6|
//字符串部分是 |30300 2 This  is test|
```

