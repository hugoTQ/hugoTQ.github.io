spritf、strcpy、memcpy能不能互换





1. `sprintf` is dangerous, deprecated, and superseded by `snprintf`. The only way to use the old `sprintf` safely with string inputs is to either measure their length before calling `sprintf`, which is ugly and error-prone, or by adding a field precision specifier (e.g. `%.8s` or `%.*s` with an extra integer argument for the size limit). This is also ugly and error-prone, especially if more than one `%s` specifier is involved.
2. `strncpy` is also dangerous. It is **not** a buffer-size-limited version of `strcpy`. It's a function for copying characters into a fixed-length, null-*padded* (as opposed to null-*terminated*) array, where the source may be either a C string or a fixed-length character array at least the size of the destination. Its intended use was for legacy unix directory tables, database entries, etc. that worked with fixed-size text fields and did not want to waste even a single byte on disk or in memory for null termination. It *can* be misused as a buffer-size-limited `strcpy`, but doing so is harmful for two reasons. First of all, it fails to null terminate if the whole buffer is used for string data (i.e. if the source string length is at least as long as the dest buffer). You can add the termination back yourself, but this is ugly and error-prone. And second, `strncpy` always pads the full destination buffer with null bytes when the source string is shorter than the output buffer. This is simply a waste of time.

So what should you use instead?

Some people like the BSD `strlcpy` function. Semantically, it's identical to `snprintf(dest, destsize, "%s", source)` except that the return value is `size_t` and it does not impose an artificial `INT_MAX`limit on string length. However, most popular non-BSD systems lack `strlcpy`, and it's easy to make dangerous errors writing your own, so if you want to use it, you should obtain a safe, known-working version from a trustworthy source.

My preference is to simply use `snprintf` for any nontrivial string construction, and `strlen`+`memcpy`for some trivial cases that have been measured to be performance-critical. If you get in a habit of using this idiom correctly, it becomes almost impossible to accidentally write code with string-related vulnerabilities.

