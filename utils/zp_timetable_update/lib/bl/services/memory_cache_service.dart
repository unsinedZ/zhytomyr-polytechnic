class MemoryCacheService {
  var _cache = Map<String, CacheEntry>();

  int get currentCacheSize => _cache.length;

  dynamic get(String key) {
    if (_cache.containsKey(key)) {
      CacheEntry? entry = _cache[key];
      if (entry != null && entry.expireAt.isAfter(DateTime.now())) {
        return entry.item;
      }
    }
    return null;
  }

  void addOrUpdate(String key, dynamic value, Duration timeToLive) {
    _cache[key] = CacheEntry(value, timeToLive);
  }

  void remove(String key) {
    if (_cache.containsKey(key)) {
      _cache.remove(key);
    }
  }

  void clean() {
    var keys = <String>[];
    for (var item in _cache.entries) {
      if (item.value.expireAt.isBefore(DateTime.now())) {
        keys.add(item.key);
      }
    }
    for (var key in keys) {
      _cache.remove(key);
    }
  }
}

class CacheEntry<T> {
  T item;
  DateTime expireAt;

  CacheEntry(this.item, Duration timeToLive)
      : expireAt = DateTime.now().add(timeToLive);
}