package name.sitorhy.server.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import name.sitorhy.server.model.*;
import name.sitorhy.server.session.RequestHeadersSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;
import reactor.core.scheduler.Schedulers;

import java.text.SimpleDateFormat;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

@Service
public class CategoryService {
    private RequestHeadersSession requestHeadersSession;

    @Autowired
    public void setRequestHeadersSession(RequestHeadersSession requestHeadersSession) {
        this.requestHeadersSession = requestHeadersSession;
    }

    // 首页推荐分类的信息
    public Mono<List<CategoryGroup>> getCategories() {
        return requestHeadersSession.get("https://y.qq.com/",
                        new LinkedHashMap<>())
                .retrieve()
                .bodyToMono(String.class)
                .publishOn(Schedulers.boundedElastic())
                .handle((htmlText, sink) -> {
                    try {
                        List<CategoryGroup> groups = new ArrayList<>();
                        Thread[] tasks = new Thread[]{
                                new Thread(() -> {
                                    try {
                                        Pattern regex = Pattern.compile("\"hotCategory\":\\[[^\\]]*\\]");
                                        Matcher matcher = regex.matcher(htmlText);
                                        if (matcher.find()) {
                                            String matchText = matcher.group(0);
                                            ObjectMapper mapper = new ObjectMapper();
                                            JsonNode root = mapper.readTree("{" + matchText + "}");
                                            JsonNode nodes = root.at("/hotCategory");
                                            List<CategoryMeta> categories = StreamSupport.stream(nodes.spliterator(), false).map((i) -> new CategoryMeta() {{
                                                setCategoryName(i.at("/name").asText());
                                                setCategoryCode(i.at("/id").asText());
                                                if (i.at("/id").asText().equals("0")) {
                                                    setCategoryType(CategoryTypeEnum.RECOMMEND_FOR_ME);
                                                } else {
                                                    setCategoryType(CategoryTypeEnum.RECOMMEND);
                                                }
                                            }}).collect(Collectors.toUnmodifiableList());
                                            groups.add(new CategoryGroup() {{
                                                setTitle("歌单推荐");
                                                setCategoryTypes(Arrays.asList(new String[] {
                                                        CategoryTypeEnum.RECOMMEND_FOR_ME.toString(),
                                                        CategoryTypeEnum.RECOMMEND.toString()
                                                }));
                                                setCategories(categories);
                                            }});
                                        }
                                    } catch (Exception e) {
                                        throw new RuntimeException(e);
                                    }
                                }),
                                new Thread(() -> {
                                    try {
                                        String jsonText = requestHeadersSession.post("http://u.y.qq.com/cgi-bin/musicu.fcg",
                                                        new LinkedHashMap<>() {{
                                                            put("_", System.currentTimeMillis());
                                                        }},
                                                        new LinkedHashMap<>() {
                                                            {
                                                                put("comm", new LinkedHashMap<String, Object>() {{
                                                                    put("ct", 24);
                                                                }});
                                                                put("recomPlaylist", new LinkedHashMap<String, Object>() {{
                                                                    put("method", "get_new_album_area");
                                                                    put("param", new LinkedHashMap<String, Object>());
                                                                    put("module", "newalbum.NewAlbumServer");
                                                                }});
                                                            }
                                                        })
                                                .retrieve()
                                                .bodyToMono(String.class).block();

                                        List<CategoryMeta> categories = new ArrayList<>();
                                        ObjectMapper mapper = new ObjectMapper();
                                        JsonNode root = mapper.readTree(jsonText);
                                        JsonNode listNode = root.at("/recomPlaylist/data/area");
                                        if (listNode.isArray()) {
                                            for (JsonNode node : listNode) {
                                                categories.add(new CategoryMeta() {{
                                                    setCategoryName(node.at("/name").asText());
                                                    setCategoryCode(node.at("/id").asText());
                                                    setCategoryType(CategoryTypeEnum.NEW_ALBUM);
                                                }});
                                            }
                                        }
                                        groups.add(new CategoryGroup() {{
                                            setTitle("新碟首发");
                                            setCategoryTypes(Arrays.asList(new String[] {
                                                    CategoryTypeEnum.NEW_ALBUM.toString(),
                                            }));
                                            setCategories(categories);
                                        }});
                                    } catch (Exception e) {
                                        throw new RuntimeException(e);
                                    }
                                }),
                                new Thread(() -> {
                                    try {
                                        String jsonText = requestHeadersSession.post("http://u.y.qq.com/cgi-bin/musicu.fcg",
                                                        new LinkedHashMap<>() {{
                                                            put("_", System.currentTimeMillis());
                                                        }},
                                                        new LinkedHashMap<>() {
                                                            {
                                                                put("comm", new LinkedHashMap<String, Object>() {{
                                                                    put("ct", 24);
                                                                }});
                                                                put("recomPlaylist", new LinkedHashMap<String, Object>() {{
                                                                    put("method", "get_new_song_info");
                                                                    put("param", new LinkedHashMap<String, Object>());
                                                                    put("module", "newsong.NewSongServer");
                                                                }});
                                                            }
                                                        })
                                                .retrieve()
                                                .bodyToMono(String.class).block();

                                        List<CategoryMeta> categories = new ArrayList<>();
                                        ObjectMapper mapper = new ObjectMapper();
                                        JsonNode root = mapper.readTree(jsonText);
                                        JsonNode listNode = root.at("/recomPlaylist/data/lanlist");
                                        if (listNode.isArray()) {
                                            for (JsonNode node : listNode) {
                                                categories.add(new CategoryMeta() {{
                                                    setCategoryName(node.at("/lan").asText());
                                                    setCategoryCode(node.at("/type").asText());
                                                    setCategoryType(CategoryTypeEnum.NEW_SONG);
                                                }});
                                            }
                                        }
                                        groups.add(new CategoryGroup() {{
                                            setTitle("新歌首发");
                                            setCategoryTypes(Arrays.asList(new String[] {
                                                    CategoryTypeEnum.NEW_SONG.toString(),
                                            }));
                                            setCategories(categories);
                                        }});
                                    } catch (Exception e) {
                                        throw new RuntimeException(e);
                                    }
                                }),
                                new Thread(() -> {
                                    try {
                                        String jsonText = requestHeadersSession.post("http://u.y.qq.com/cgi-bin/musicu.fcg",
                                                        new LinkedHashMap<>() {{
                                                            put("_", System.currentTimeMillis());
                                                        }},
                                                        new LinkedHashMap<>() {
                                                            {
                                                                put("comm", new LinkedHashMap<String, Object>() {{
                                                                    put("ct", 24);
                                                                }});
                                                                put("recomPlaylist", new LinkedHashMap<String, Object>() {{
                                                                    put("method", "GetAll");
                                                                    put("param", new LinkedHashMap<String, Object>());
                                                                    put("module", "musicToplist.ToplistInfoServer");
                                                                }});
                                                            }
                                                        })
                                                .retrieve()
                                                .bodyToMono(String.class).block();

                                        List<CategoryMeta> categories = new ArrayList<>();
                                        ObjectMapper mapper = new ObjectMapper();
                                        JsonNode root = mapper.readTree(jsonText);
                                        JsonNode listNode = root.at("/recomPlaylist/data/group");

                                        if (listNode.isArray()) {
                                            for (JsonNode node : listNode) {
                                                String groupId = node.at("/groupId").asText();
                                                String groupName = node.at("/groupName").asText();

                                                JsonNode topListNode = node.at("/toplist");
                                                if (topListNode.isArray()) {
                                                    for (JsonNode top : topListNode) {
                                                        categories.add(new CategoryMeta() {{
                                                            setCategoryName(top.at("/title").asText());
                                                            setCategoryCode(top.at("/topId").asText());
                                                            setGroupId(groupId);
                                                            setGroupName(groupName);
                                                            setCategoryType(CategoryTypeEnum.TOP_LIST);
                                                        }});
                                                    }
                                                }
                                            }
                                        }
                                        groups.add(new CategoryGroup() {{
                                            setTitle("排行榜");
                                            setCategoryTypes(Arrays.asList(new String[] {
                                                    CategoryTypeEnum.TOP_LIST.toString(),
                                            }));
                                            setCategories(categories);
                                        }});
                                    } catch (Exception e) {
                                        throw new RuntimeException(e);
                                    }
                                })
                        };
                        List<Throwable> exceptions = new ArrayList<>();
                        for (Thread task : tasks) {
                            task.setUncaughtExceptionHandler((_, e) -> exceptions.add(e));
                            task.start();
                        }
                        for (Thread task : tasks) {
                            task.join();
                        }
                        if (!exceptions.isEmpty()) {
                            sink.error(exceptions.getFirst());
                            return;
                        }
                        sink.next(groups);
                    } catch (Exception e) {
                        sink.error(e);
                    }
                });
    }

    public Mono<Category> getCategoryDetail(String categoryType, long code, long pageNo, long pageSize) {
        CategoryTypeEnum type = CategoryTypeEnum.valueOf(categoryType);
        return switch (type) {
            case RECOMMEND_FOR_ME -> getRecommendForMe(pageNo, pageSize);
            case RECOMMEND -> getRecommend(code, pageNo, pageSize);
            case NEW_SONG -> getNewSong(code, pageNo, pageSize);
            case NEW_ALBUM -> getNewAlbum(code, pageNo, pageSize);
            case TOP_LIST -> getTopList(code, pageNo, pageSize);
            default -> Mono.just(new Category());
        };
    }

    // 为你推荐 不支持翻页查询
    public Mono<Category> getRecommendForMe(long pageNo, long pageSize) {
        return requestHeadersSession.post("http://u.y.qq.com/cgi-bin/musicu.fcg",
                        new LinkedHashMap<>() {{
                            put("_", System.currentTimeMillis());
                        }},
                        new LinkedHashMap<>() {
                            {
                                put("comm", new LinkedHashMap<String, Object>() {{
                                    put("ct", 24);
                                }});
                                put("recomPlaylist", new LinkedHashMap<String, Object>() {{
                                    put("method", "GetRecommendFeed");
                                    put("param", new LinkedHashMap<String, Object>() {{
                                        put("id", 0);
                                        put("curPage", pageNo);
                                        put("size", pageSize);
                                        put("order", 5);
                                        put("titleid", 0);
                                    }});
                                    put("module", "music.playlist.PlaylistSquare");
                                }});
                            }
                        })
                .retrieve()
                .bodyToMono(String.class)
                .handle((jsonText, sink) -> {
                    try {
                        Category category = new Category();
                        List<Album> albumList = new ArrayList<>();
                        category.setAlbums(albumList);
                        category.setCategoryCode("0");
                        category.setCategoryType(CategoryTypeEnum.RECOMMEND_FOR_ME);

                        ObjectMapper mapper = new ObjectMapper();
                        JsonNode root = mapper.readTree(jsonText);
                        JsonNode listNode = root.at("/recomPlaylist/data/List");

                        if (listNode.isArray()) {
                            JsonNode firstNode = listNode.get(0);
                            category.setCategoryName(firstNode.at("/WhereFrom").asText());
                            category.setCategoryType(CategoryTypeEnum.RECOMMEND_FOR_ME);
                            for (JsonNode node : listNode) {
                                albumList.add(new Album() {{
                                    this.setSubtitle(node.at("/Playlist/basic/desc").asText());
                                    this.setPicUrl(node.at("/Playlist/basic/cover/big_url").asText());
                                    this.setDissId(node.at("/Playlist/basic/tid").asLong());
                                    this.setTitle(node.at("/Playlist/basic/title").asText());
                                    this.setDirId(node.at("/Playlist/basic/dirid").asLong());
                                    this.setAuthor(node.at("/Playlist/basic/creator/nick").asText());
                                }});
                            }
                        }
                        category.setPageNo(pageNo);
                        category.setPageSize(pageSize);
                        category.setTotal(albumList.size());
                        sink.next(category);
                    } catch (Exception e) {
                        sink.error(e);
                    }
                });
    }

    // 歌单推荐
    public Mono<Category> getRecommend(long code, long pageNo, long pageSize) {
        return requestHeadersSession.post("http://u.y.qq.com/cgi-bin/musicu.fcg",
                        new LinkedHashMap<>() {{
                            put("_", System.currentTimeMillis());
                        }},
                        new LinkedHashMap<>() {
                            {
                                put("comm", new LinkedHashMap<String, Object>() {{
                                    put("ct", 24);
                                }});
                                put("recomPlaylist", new LinkedHashMap<String, Object>() {{
                                    put("method", "get_playlist_by_category");
                                    put("param", new LinkedHashMap<String, Object>() {{
                                        put("id", code);
                                        put("curPage", pageNo);
                                        put("size", pageSize);
                                        put("order", 5);
                                        put("titleid", code);
                                    }});
                                    put("module", "playlist.PlayListPlazaServer");
                                }});
                            }
                        })
                .retrieve()
                .bodyToMono(String.class)
                .handle((jsonText, sink) -> {
                    try {
                        Category category = new Category();
                        List<Album> albumList = new ArrayList<>();
                        category.setAlbums(albumList);
                        category.setCategoryType(CategoryTypeEnum.RECOMMEND);
                        category.setCategoryCode(Long.toString(code));

                        ObjectMapper mapper = new ObjectMapper();
                        JsonNode root = mapper.readTree(jsonText);
                        JsonNode listNode = root.at("/recomPlaylist/data/v_playlist");

                        if (listNode.isArray()) {
                            for (JsonNode node : listNode) {
                                albumList.add(new Album() {{
                                    this.setSubtitle("");
                                    this.setPicUrl(node.at("/cover_url_big").asText());
                                    this.setDissId(node.at("/tid").asLong());
                                    this.setTitle(node.at("/title").asText());
                                    this.setDirId(node.at("/dirid").asLong());
                                    this.setAuthor(node.at("/creator_info/nick").asText());
                                }});
                            }
                        }
                        category.setPageNo(pageNo);
                        category.setPageSize(pageSize);
                        category.setTotal(root.at("/recomPlaylist/data/total").asLong());
                        sink.next(category);
                    } catch (Exception e) {
                        sink.error(e);
                    }
                });
    }

    // 新碟首发
    public Mono<Category> getNewAlbum(long code, long pageNo, long pageSize) {
        return requestHeadersSession.post("http://u.y.qq.com/cgi-bin/musicu.fcg",
                        new LinkedHashMap<>() {{
                            put("_", System.currentTimeMillis());
                        }},
                        new LinkedHashMap<>() {
                            {
                                put("comm", new LinkedHashMap<String, Object>() {{
                                    put("ct", 24);
                                }});
                                put("recomPlaylist", new LinkedHashMap<String, Object>() {{
                                    put("method", "get_new_album_info");
                                    put("param", new LinkedHashMap<String, Object>() {{
                                        put("area", code);
                                        put("start", pageNo - 1);
                                        put("sin", 0);
                                        put("num", pageSize);
                                    }});
                                    put("module", "newalbum.NewAlbumServer");
                                }});
                            }
                        })
                .retrieve()
                .bodyToMono(String.class)
                .handle((jsonText, sink) -> {
                    try {
                        Category category = new Category();
                        List<Album> albumList = new ArrayList<>();
                        category.setAlbums(albumList);
                        category.setCategoryType(CategoryTypeEnum.NEW_ALBUM);
                        category.setCategoryCode(Long.toString(code));

                        ObjectMapper mapper = new ObjectMapper();
                        JsonNode root = mapper.readTree(jsonText);
                        JsonNode listNode = root.at("/recomPlaylist/data/albums");

                        if (listNode.isArray()) {
                            for (JsonNode node : listNode) {
                                albumList.add(new Album() {{
                                    this.setSubtitle("");
                                    this.setPicUrl(String.format("https://y.qq.com/music/photo_new/T002R300x300M000%s.jpg", node.at("/mid").asText()));
                                    this.setDissId(node.at("/id").asLong());
                                    this.setTitle(node.at("/name").asText());

                                    this.setSingers(new ArrayList<>());
                                    JsonNode arrSingerList = node.at("/singers");
                                    for (JsonNode singerNode : arrSingerList) {
                                        this.getSingers().add(new Singer() {{
                                            setId(singerNode.at("/id").asLong());
                                            setMid(singerNode.at("/mid").asText());
                                            setName(singerNode.at("/name").asText());
                                        }});
                                    }
                                    this.setAuthor(String.join(" /", this.getSingers().stream().map(Singer::getName).toList()));
                                }});
                            }
                        }
                        category.setPageNo(pageNo);
                        category.setPageSize(pageSize);
                        category.setTotal(albumList.size());
                        sink.next(category);
                    } catch (Exception e) {
                        sink.error(e);
                    }
                });
    }

    // 新歌首发
    public Mono<Category> getNewSong(long code, long pageNo, long pageSize) {
        return requestHeadersSession.post("http://u.y.qq.com/cgi-bin/musicu.fcg",
                        new LinkedHashMap<>() {{
                            put("_", System.currentTimeMillis());
                        }},
                        new LinkedHashMap<>() {
                            {
                                put("comm", new LinkedHashMap<String, Object>() {{
                                    put("ct", 24);
                                }});
                                put("recomPlaylist", new LinkedHashMap<String, Object>() {{
                                    put("method", "get_new_song_info");
                                    put("param", new LinkedHashMap<String, Object>() {{
                                        put("type", code);
                                    }});
                                    put("module", "newsong.NewSongServer");
                                }});
                            }
                        })
                .retrieve()
                .bodyToMono(String.class)
                .handle((jsonText, sink) -> {
                    try {
                        Category category = new Category();
                        List<Song> songList = new ArrayList<>();
                        category.setSongs(songList);

                        ObjectMapper mapper = new ObjectMapper();
                        JsonNode root = mapper.readTree(jsonText);
                        JsonNode listNode = root.at("/recomPlaylist/data/songlist");

                        category.setCategoryName(root.at("/recomPlaylist/data/lan").asText());
                        category.setCategoryCode(Long.toString(code));
                        category.setCategoryType(CategoryTypeEnum.NEW_SONG);

                        if (listNode.isArray()) {
                            for (JsonNode songInfoNode : listNode) {
                                songList.add(new Song() {{
                                    this.setSongId(songInfoNode.at("/id").asLong());
                                    this.setSongMid(songInfoNode.at("/mid").asText());
                                    this.setSongName(songInfoNode.at("/name").asText());
                                    this.setSongOrig(songInfoNode.at("/title").asText());
                                    this.setAlbumDesc(songInfoNode.at("/album/subtitle").asText());
                                    this.setAlbumId(songInfoNode.at("/album/id").asLong());
                                    this.setAlbumName(songInfoNode.at("/album/name").asText());
                                    this.setAlbumMid(songInfoNode.at("/album/mid").asText());
                                    this.setStrMediaMid(songInfoNode.at("/file/media_mid").asText());
                                    this.setInterval(songInfoNode.at("/interval").asLong());
                                    this.setAlbumCoverUrl(String.format("https://y.qq.com/music/photo_new/T002R300x300M000%s.jpg", this.getAlbumMid()));

                                    this.setSingers(new ArrayList<>());
                                    JsonNode arrSingerList = songInfoNode.at("/singer");
                                    for (JsonNode singerNode : arrSingerList) {
                                        this.getSingers().add(new Singer() {{
                                            setId(singerNode.at("/id").asLong());
                                            setMid(singerNode.at("/mid").asText());
                                            setName(singerNode.at("/name").asText());
                                        }});
                                    }
                                }});
                            }
                        }
                        category.setPageNo(pageNo);
                        category.setPageSize(pageSize);
                        category.setTotal(songList.size());
                        sink.next(category);
                    } catch (Exception e) {
                        sink.error(e);
                    }
                });
    }

    // 新歌首发
    public Mono<Category> getTopList(long code, long pageNo, long pageSize) {
        return requestHeadersSession.post("http://u.y.qq.com/cgi-bin/musicu.fcg",
                        new LinkedHashMap<>() {{
                            put("_", System.currentTimeMillis());
                        }},
                        new LinkedHashMap<>() {
                            {
                                put("comm", new LinkedHashMap<String, Object>() {{
                                    put("ct", 24);
                                }});
                                put("recomPlaylist", new LinkedHashMap<String, Object>() {{
                                    put("method", "GetDetail");
                                    put("param", new LinkedHashMap<String, Object>() {{
                                        put("topid", code);
                                        put("offset", pageNo - 1);
                                        put("num", pageSize);
                                        put("period", new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
                                    }});
                                    put("module", "musicToplist.ToplistInfoServer");
                                }});
                            }
                        })
                .retrieve()
                .bodyToMono(String.class)
                .handle((jsonText, sink) -> {
                    try {
                        Category category = new Category();
                        List<Song> songList = new ArrayList<>();
                        category.setSongs(songList);

                        ObjectMapper mapper = new ObjectMapper();
                        JsonNode root = mapper.readTree(jsonText);
                        JsonNode listNode = root.at("/recomPlaylist/data/data/song");

                        category.setCategoryType(CategoryTypeEnum.TOP_LIST);
                        category.setCategoryCode(root.at("/recomPlaylist/data/data/topId").asText());
                        category.setCategoryName(root.at("/recomPlaylist/data/data/title").asText());

                        if (listNode.isArray()) {
                            for (JsonNode songInfoNode : listNode) {
                                songList.add(new Song() {{
                                    this.setSongId(songInfoNode.at("/songId").asLong());
                                    this.setSongName(songInfoNode.at("/title").asText());
                                    this.setSongOrig(songInfoNode.at("/title").asText());
                                    this.setAlbumMid(songInfoNode.at("/albumMid").asText());
                                    this.setAlbumCoverUrl(songInfoNode.at("/cover").asText());

                                    this.setSingers(Arrays.asList(new Singer[] {
                                            new Singer() {{
                                                setName(songInfoNode.at("/singerName").asText());
                                                setMid(songInfoNode.at("/singerMid").asText());
                                            }}
                                    }));
                                }});
                            }
                        }
                        category.setPageNo(pageNo);
                        category.setPageSize(pageSize);
                        category.setTotal(songList.size());
                        sink.next(category);
                    } catch (Exception e) {
                        sink.error(e);
                    }
                });
    }
}
