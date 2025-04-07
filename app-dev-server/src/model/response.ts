export class Response<T> {
  public data: T;
  public code: number = 0;
  public message: string = '';

  constructor(options: {
    data: T;
    code?: number;
    message?: string;
  }) {
    if (options.code !== undefined) {
      this.code = options.code;
    }
    if (options.message !== undefined) {
      this.message = options.message;
    }
    this.data = options.data;
  }
}

export class PaginationResponse<T> extends Response<T> {
  public pageNo: number;
  public pageSize: number;
  public total: number;

  constructor(options: {
    data: T;
    code?: number;
    message?: string;
    pageNo: number;
    pageSize: number;
    total: number;
  }) {
    super(options);
    this.pageNo = options.pageNo;
    this.pageSize = options.pageSize;
    this.total = options.total;
  }
}