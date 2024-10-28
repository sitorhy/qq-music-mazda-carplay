import {config} from 'axios-annotations/core/config';
import RequestMapping from "axios-annotations/decorator/request-mapping";
import Service from "axios-annotations/core/service";
import RequestParam from "axios-annotations/decorator/request-param";

config.protocol = "http";
config.host = "localhost";
config.port = 5173;
config.prefix = "/api";

@RequestMapping("/")
class QQMusicAPI extends Service {

    @RequestParam("pageNo", true)
    @RequestParam("pageSize", true)
    @RequestParam("code", true)
    @RequestParam("type", true)
    @RequestMapping("/category/detail", "GET")
    getCategoryDetail(params: {
        pageNo: number,
        pageSize: number,
        code: number,
        type: string;
    }) {
        return {
            ...params
        };
    }

    @RequestMapping("/category/list", "GET")
    getCategoryList() {
        return {};
    }

    @RequestMapping("/album/my/albums", "GET")
    getMyAlbumList() {
        return {};
    }

    @RequestMapping("/album/fav/public", "GET")
    getMyFavPubList() {
        return {};
    }

    @RequestMapping("/album/fav/albums", "GET")
    getFavAlbumList() {
        return {};
    }

    @RequestParam("pageNo", false)
    @RequestParam("pageSize", false)
    @RequestParam("resId", true)
    @RequestMapping("/song/list/{resId}", "GET")
    getSongs(params: {
        resId: string | number;
        pageNo?: number;
        pageSize?: number;
    }) {
        return {
            ...params,
            pageNo: params.pageNo || 1,
            pageSize: params.pageSize || 20,
        };
    }
}

export default QQMusicAPI;