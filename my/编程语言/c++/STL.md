# STL 

## vetor

1. 构造

   ```c
   Vector<T> v1; //默认构造函数v1为空
   Vector<T> v2(v1);//v2是v1的一个副本
   Vector<T> v4(n); //v4含有n个值为0的元素
   
   // 通过assign，vector初始化另一个vector
   vector v(10,0); // {0,0,0,0,0,0,0,0,0,0}
   vector v1;
   v1.assign(10, 0); // v1 設 10 個 0
   v1.assign(v.begin(), v.end()); // v1 複制 v
   v1.assign(v.begin(), v.begin()+5); // 複製 v 前5個元素到 v1
   v1.assign(array, array+5); // 複製 array 前5個元素到 v1
   
   // 通过assign，数组初始化另一个vector
   int array[] = {0,1,2,3,4};
   v2.assign(array, array+5); // 複製 array 前5個元素到 v1
   
   // vector初始化另一个vector
   vector v3(v.begin(), v.end())
       
   // 二维vector
   vector< vector<int> > array_2D;
   ```

2. 添加

   ```c
   a.push_back(val) //若vector已满，会自动alloc更大内存，并拷贝之前的元素到新内存，再把元素添加到vector末尾
   a.insert(iter, n, val); // iter前插入n个val
   a.insert(iter, val); 	// iter前插入val
   ```

3. 删除

   ```c
   v.pop_back();	// 去掉数组的最后一个数据
   v.clear();		// 删除所有元素
   v.erase(vec.begin()+2);	//删除第3个元素
   v.erase(vec.begin()+i,vec.end()+j);	// 删除区间[i,j），注意是前闭后开
   ```

4. 查找

   ```c
   v[];		// 会越界造成崩溃
   v.at();		// 比[]安全，越界保护，会抛异常
   v.back();	// 返回最后一个元素
   v.fornt();	// 返回第一个元素
   
   ```

5. 迭代器

   ```c
   v.begin(); // 回傳一個 iterator，它指向 vector 第一個元素。
   v.end();	// 回傳一個 iterator，它指向 vector 最尾端元素的下一個位置（請注意：它不是最末元素）。
   v.rbegin(); // 回傳一個反向 iterator，它指向 vector 最尾端元素的。
   v.rend();	// 回傳一個 iterator，它指向 vector 的第一個元素。
   for(it=v.begin(); it!=v.end(); ++it) cout << *it << " "; // 一般迭代方法
   ```

   

6. 其他

   ```c
   v.get_allocator();	// 返回一个副本
   v.reserve(iter1, iter2);	// 将元素翻转，需要 include <algorithm>
   v.sort(iter1, iter2);	// 从小到大排序
   v.resize(size, val);	// 
   v.size();	// 大小
   v.swap(v2);	// 交换两个vector
   v.capacity();	// 容量
   v.max_size();	// vector的极限容量
   ```

7. 关于reseve 和reisze

   reserve(val)后，元素不发生改变，capicity增加到val，val比实际容量小时不会改变容量。

   resize(val)后，size会增加到val，初始化为0，capicity增加到val，当val比实际size小时，会删除元素。

   可以看出，reserve没有插入元素，resize插入/删除了元素。

   

   ## list

   1. 基本与vector操作一样：

      ```C
      list<int> c0; //空链表
      list<int> c1(3); //建一个含三个默认值是0的元素的链表
      list<int> c2(5,2); //建一个含五个元素的链表，值都是2
      list<int> c4(c2); //建一个c2的copy链表
      list<int> c5(c1.begin(),c1.end()); ////c5含c1一个区域的元素[_First, _Last)。
      c.assign(n,num)      //将n个num拷贝赋值给链表c。
      c.assign(beg,end)     // 将[beg,end)区间的元素拷贝赋值给链表c。
      
      c.begin()	//返回指向链表第一个元素的迭代器。
      c.end()      //返回指向链表最后一个元素之后的迭代器。
      c.rbegin()     // 返回逆向链表的第一个元素,即c链表的最后一个数据。
      c.rend()     // 返回逆向链表的最后一个元素的下一个位置,即c链表的第一个数据再往前的位置。
          
      c.front()      //返回链表c的第一个元素。
      c.back()      //返回链表c的最后一个元素。
      c.empty()  // 判断链表是否为空。
      c.size()     // 返回链表c中实际元素的个数。
      c.clear()     // 清除链表c中的所有元素
      
      c.insert(pos,num)    //  在pos位置插入元素num。
      c.insert(pos,n,num)    //  在pos位置插入n个元素num。
      c.insert(pos,beg,end)     // 在pos位置插入区间为[beg,end)的元素。
      c.push_back(num)      //在末尾增加一个元素。
      c.pop_back()     // 删除末尾的元素。
      c.erase(pos)　　　　//删除pos位置的元素。
      ```

   2. 比vector多了两个插入操作和一些两个list操作

      ```C
      c.push_front(num)      //在开始位置增加一个元素。
      c.pop_front()      //删除第一个元素。
      
      c1.merge(c2)      //合并2个有序的链表并使之有序,从新放到c1里,释放c2。
      c1.merge(c2,comp)   //   合并2个有序的链表并使之按照自定义规则排序之后从新放到c1中,释放c2。
          
      c1.splice(c1.beg,c2)      //将c2连接在c1的beg位置,释放c2
      c1.splice(c1.beg,c2,c2.beg)     // 将c2的beg位置的元素连接到c1的beg位置，并且在c2中施放掉beg位置的元素
      c1.splice(c1.beg,c2,c2.beg,c2.end)      //将c2的[beg,end)位置的元素连接到c1的beg位置并且释放c2的[beg,end)位置的元素
          
      c.remove(num)             //删除链表中匹配num的元素,调用一次则删除多个
      ```

      

      

   