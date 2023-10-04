from fastapi import FastAPI, HTTPException


def create_app() -> FastAPI:
    
    return FastAPI()


app = create_app()


@app.get("/decoder/health")
def get_root():
    return {"message": f"Welcome to the decoder API."}



# docker build -t circle_playground .
# docker run -d -p 80:80 circle_playground
# docker run -p 80:80 circle_playground