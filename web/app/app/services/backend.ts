import {Injectable} from 'angular2/core';
import {Http} from 'angular2/http';

@Injectable()
export class BackendService {
  private verbose: boolean = true;
  private baseUrl: string = "api/";

  constructor(private http: Http){
  }

  private urlHandler(url: string | Array<any>): string {
    var cleanUrl: string;
    if (url instanceof Array){
      var tempUrl = "";
      (<Array<any>>url).forEach(subPath => {
        tempUrl += subPath + "/";
      });
      cleanUrl = tempUrl;
    }
    else cleanUrl = <string>url;
    if (cleanUrl.charAt(cleanUrl.length-1) == "/") return cleanUrl.substring(0, cleanUrl.length - 1);
    return cleanUrl;
  }

  get(url: string | Array<any>): Promise<any>{
    return new Promise((resolve, reject) => {
      this.http
      .get(this.baseUrl + this.urlHandler(url))
      .subscribe((resp) => {
        if (resp.status < 300){
          try {
            var data = resp.json();
            resolve(data);
          }
          catch (e) {
            if (this.verbose) {
              console.error("'GET %s' -> error parsing data", resp.url)
              console.error(e);
            }
            reject(resp);
          }
        }
        else {
          if (this.verbose) console.error("'%s' -> failed to get from server with code: '%d' %s", resp.url, resp.status, resp.statusText);
          reject(resp);
        }
      });
    });
  }

  post(url: string | Array<any>, body: any): Promise<any>{
    return new Promise((resolve, reject) => {
      this.http
        .post(this.baseUrl + this.urlHandler(url), body)
        .subscribe((resp) => {
          if (resp.status < 300){
            try {
              var data = resp.json();
              resolve(data);
            }
            catch (e) {
              if (this.verbose) {
                console.error("'POST %s' -> error parsing data", resp.url)
                console.error(e);
              }
              reject(resp);
            }
          }
          else {
            if (this.verbose) console.error("'%s' -> failed to post to server with code: '%d' %s, for data ->\n %s", resp.url, resp.status, resp.statusText, JSON.stringify(body));
            reject(resp);
          }
        });
    });
  }

  put(url: string | Array<any>, body: any): Promise<any>{
    return new Promise((resolve, reject) => {
      this.http
        .put(this.baseUrl + this.urlHandler(url), body)
        .subscribe((resp) => {
          if (resp.status < 300){
            try {
              var data = resp.json();
              resolve(data);
            }
            catch (e) {
              if (this.verbose) {
                console.error("'PUT %s' -> error parsing data", resp.url)
                console.error(e);
              }
              reject(resp);
            }
          }
          else {
            if (this.verbose) console.error("'%s' -> failed to put to server with code: '%d' %s, for data ->\n %s", resp.url, resp.status, resp.statusText, JSON.stringify(body));
            reject(resp);
          }
        });
    });
  }

  delete(url: string | Array<any>){
    return new Promise((resolve, reject) => {
      this.http
        .delete(this.baseUrl + this.urlHandler(url))
        .subscribe((resp) => {
          if (resp.status < 300) resolve(resp);
          else {
            if (this.verbose) console.error("'%s' -> failed to delete from server with code: '%d' %s", resp.url, resp.status, resp.statusText);
            reject(resp);
          }
        });
    });
  }
}
