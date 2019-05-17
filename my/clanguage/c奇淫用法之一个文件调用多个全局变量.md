#define REGISTER_FILTER(X, x, y)                                        \
    {                                                                   \
        extern AVFilter ff_##y##_##x;                                   \
        if (CONFIG_##X##_FILTER)                                        \
            avfilter_register(&ff_##y##_##x);                           \
    }

