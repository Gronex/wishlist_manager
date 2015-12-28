import {Injectable} from 'angular2/core';
import {Http} from 'angular2/http';

@Injectable()
export class BackendService {
  private verbose: boolean = true;
  private baseUrl: string = "http://localhost:4000/api";

  constructor(private http: Http){}

  private urlHandler(path: Array<string>, resource: string, id?: string |number): string {
    var cleanUrl: string = "";
    if (path) cleanUrl = path.join("/");
    cleanUrl += "/" + resource;
    if (id) cleanUrl += "/" + id;
    return this.baseUrl + cleanUrl;
  }

  private wrapData(holder: string, data: any): string{
    var wrapped = {};
    if (holder.endsWith("s")) holder = holder.substring(0, holder.length - 1);
    wrapped[holder] = data;
    return JSON.stringify(wrapped);
  }

  //get(url: string | Array<any>): Promise<any>{
  get(resource: string, id?: string | number, path?: Array<string>): Promise<any>{
    return new Promise((resolve, reject) => {
      this.http
      .get(this.urlHandler(path, resource, id))
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

  post(body: any, resource: string, path?: Array<string>): Promise<any>{
    return new Promise((resolve, reject) => {
      this.http
        .post(this.urlHandler(path, resource), this.wrapData(resource, body))
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

  put(body: any, resource: string, id: string | number, path?: Array<string>): Promise<any>{
    return new Promise((resolve, reject) => {
      this.http
        .put(this.urlHandler(path, resource, id), this.wrapData(resource, body))
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

  delete(resource: string, id: string | number, path?: Array<string>){
    return new Promise((resolve, reject) => {
      this.http
        .delete(this.urlHandler(path, resource, id))
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
