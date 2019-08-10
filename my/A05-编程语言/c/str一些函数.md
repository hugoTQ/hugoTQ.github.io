```c
size_t strspn(const char *s, const char *charset);//返回s以charset开头的公共子串长度
char* strrchr(const char *s, int c);//返回s字符c第一次出现指针，若返回'\0'，表示s没有c
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

